/* This file contains code for a generic page fault handler for processes. */
#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "elf.h"

#include "sleeplock.h"
#include "fs.h"
#include "buf.h"

int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz);
int flags2perm(int flags);

/* CSE 536: (2.4) read current time. */
uint64 read_current_timestamp() {
  uint64 curticks = 0;
  acquire(&tickslock);
  curticks = ticks;
  wakeup(&ticks);
  release(&tickslock);
  return curticks;
}

bool psa_tracker[PSASIZE];

/* All blocks are free during initialization. */
void init_psa_regions(void)
{
    for (int i = 0; i < PSASIZE; i++) 
        psa_tracker[i] = false;
}

/* Evict heap page to disk when resident pages exceed limit */
void evict_page_to_disk(struct proc* p) {
    /* Find free block */
    int blockno;
    for (int i = 0; i < PSASIZE; i+=4){
        if (psa_tracker[i] == false) {
            blockno = i;

            break;
        }
    }
    
    /* Find victim page using FIFO. */
    
    uint64 min_time = 0xFFFFFFFFFFFFFFFF;
    int replace_index = -1;
    for (int i = 0; i < MAXHEAP; i++) {
        if (p->heap_tracker[i].loaded) {
            if (p->heap_tracker[i].last_load_time < min_time) {
                replace_index = i;
                min_time = p->heap_tracker[i].last_load_time;
            }
        }
    }

    if (p->heap_tracker[replace_index].startblock > -1) {
        blockno = p->heap_tracker[replace_index].startblock ;
    }
    
    /* Print statement. */
    print_evict_page(p->heap_tracker[replace_index].addr, blockno);
    /* Read memory from the user to kernel memory first. */
    char *new_kernel_page = kalloc();
    copyin(p->pagetable, new_kernel_page, p->heap_tracker[replace_index].addr, PGSIZE);
    
    /* Write to the disk blocks. Below is a template as to how this works. There is
     * definitely a better way but this works for now. :p */
    struct buf* b;

    for (int i = 0; i < 4; i++) {
        b = bread(1, PSASTART + blockno + i);
        psa_tracker[blockno+i] = true;
            // Copy page contents to b.data using memmove.
        memmove(b->data, new_kernel_page + i*(PGSIZE/4), PGSIZE/4);
        bwrite(b);
        brelse(b);
    }

    /* Unmap swapped out page */
    uvmunmap(p->pagetable, p->heap_tracker[replace_index].addr, 1, 1);
    
    /* Update the resident heap tracker. */
    p->heap_tracker[replace_index].loaded = false;
    p->heap_tracker[replace_index].startblock = blockno;
    p->resident_heap_pages--;
    kfree(new_kernel_page);
}

/* Retrieve faulted page from disk. */
void retrieve_page_from_disk(struct proc* p, uint64 uvaddr) {
    /* Find where the page is located in disk */
    int blockno, replacement_index;

    for (int i = 0; i < MAXHEAP; i++) {
        if (p->heap_tracker[i].addr == uvaddr) {
            blockno = p->heap_tracker[i].startblock;
            replacement_index = i;
            p->heap_tracker[i].last_load_time = read_current_timestamp();
            break;
        }
    }

    /* Print statement. */
    print_retrieve_page(p->heap_tracker[replacement_index].addr, blockno);

    /* Create a kernel page to read memory temporarily into first. */
    char *new_kernel_page = kalloc();
    
    /* Read the disk block into temp kernel page. */
    struct buf* b;

    for (int i = 0; i < 4; i++) {
        b = bread(1, PSASTART + blockno + i);
            // Copy page contents from b.data using memmove.
        memmove(new_kernel_page + i*(PGSIZE/4), b->data, PGSIZE/4);
        bwrite(b);
        brelse(b);
    }

    /* Copy from temp kernel page to uvaddr (use copyout) */
    copyout(p->pagetable, uvaddr, new_kernel_page, PGSIZE);
    kfree(new_kernel_page);
}


void page_fault_handler(void) 
{
    int i, off;
    uint64 sz = 0, sz1;
    struct inode *ip;
    struct elfhdr elf;
    struct proghdr ph;
    // pagetable_t pagetable = 0, oldpagetable;

    /* Current process struct */
    struct proc *p = myproc();

    /* Track whether the heap page should be brought back from disk or not. */
    bool load_from_disk = false;

    /* Find faulting address. */
    uint64 faulting_addr = 0;
    faulting_addr = r_stval();
    uint64 page_fault_base = (faulting_addr >> 12) << 12;

    print_page_fault(p->name, page_fault_base);

    /* Check if the fault address is a heap page. Use p->heap_tracker */
    int heap_ind;
    for (int i = 0; i < MAXHEAP; i++) {
        if (p->heap_tracker[i].addr == page_fault_base) {
            if (p->heap_tracker[i].startblock > -1) {
                load_from_disk = true;
            }
            int heap_ind = i;
            goto heap_handle;
        } else if (p->heap_tracker[i].addr == 0xFFFFFFFFFFFFFFFF) {
            break;
        }
    }
    
    
    ip = namei(p->name);
    readi(ip, 0, (uint64)&elf, 0, sizeof(elf));

    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
        readi(ip, 0, (uint64)&ph, off, sizeof(ph));
        

        if(ph.paddr == page_fault_base) {
            if(ph.type  != ELF_PROG_LOAD)
                continue;

            sz1 = uvmalloc(p->pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags));
            sz = sz1;

            loadseg(p->pagetable, ph.vaddr, ip, ph.off, ph.filesz);
            print_load_seg(ph.paddr, ph.off, ph.filesz);
        } else {
            sz = ph.vaddr + ph.memsz;
        }
    }
    

    /* Go to out, since the remainder of this code is for the heap. */
    goto out;

heap_handle:
    /* 2.4: Check if resident pages are more than heap pages. If yes, evict. */
    if (p->resident_heap_pages == MAXRESHEAP) {
        evict_page_to_disk(p);
    }

    /* 2.3: Map a heap page into the process' address space. (Hint: check growproc) */
    uvmalloc(p->pagetable, page_fault_base, page_fault_base + PGSIZE, PTE_W);
    p->heap_tracker[heap_ind].loaded = true;
    
    /* 2.4: Update the last load time for the loaded heap page in p->heap_tracker. */
    p->heap_tracker[heap_ind].last_load_time = read_current_timestamp();
    
    /* 2.4: Heap page was swapped to disk previously. We must load it from disk. */
    if (load_from_disk) {
        retrieve_page_from_disk(p, page_fault_base);
    }

    /* Track that another heap page has been brought into memory. */
    p->resident_heap_pages++;

out:
    /* Flush stale page table entries. This is important to always do. */
    sfence_vma();
    return;
}