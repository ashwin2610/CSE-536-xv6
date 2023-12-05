#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"


uint64 PMPCFG_NUM = 5000; 
uint64 PMPADDR_NUM = 5000; 
enum vm_mode {M_MODE, S_MODE, U_MODE};
// Struct to keep VM registers (Sample; feel free to change.)
struct vm_reg {
    int     code;
    int     mode;
    uint64  val;
};

int current_mode = M_MODE;
struct vm_reg vm_csr[4096];
int u_reg_csr[] = {0x000 ,0x004 ,0x005, 0x040 ,0x041 ,0x042 ,0x043 ,0x044};
int m_reg_csr[] = {0xF11, 0xF12,0xF13,0xF14,0x300,0x301,0x302,0x303,0x304,0x305,0x306,0x340,0x341,0x342,0x343,0x344,
0x3A0 ,0x3A2, 0x3A3,0x3B0, 0x3B1, 0x3B2, 0x3B3, 0x3B4, 0x3B5, 0x3B6, 0x3B7, 0x3B8, 0x3B9, 0x3BA, 0x3BB, 0x3BC, 0x3BD, 0x3BE, 0x3BF};
int s_reg_csr[] = {0x100 ,0x102 ,0x103 ,0x104 ,0x105 ,0x106 ,0x140 ,0x141 ,0x142 ,0x143 ,0x144 ,0x180};


void trap_and_emulate(void) {
    /* Comes here when a VM tries to execute a supervisor instruction. */
    struct proc* p = myproc();
    /* Retrieve all required values from the instruction */
    uint64 addr     = 0;
    uint32 op       = 0;
    uint32 rd       = 0;
    uint32 funct3   = 0;
    uint32 rs1      = 0;
    uint32 uimm     = 0;
    // Read s_cause determine cause of the trap
    // printf("SCAUSE: %d\n", r_scause());
    if (r_scause() == 8) {
        // handle ecall
        if (current_mode == U_MODE) {
            current_mode = S_MODE;
        } else {
            current_mode = M_MODE;
        }
        printf("(EC at %p)\n", p->trapframe->epc);

    } else if (r_scause() == 2) {
        // handle privilge instructions 
        // Check instruction in trapframe epc => decode => check if valid instruction
        uint64 epc = p->trapframe->epc;

        // uint64 memaddr = 0x80000000;
        addr = epc;        

        // uint32 instr = * (uint32 *)(memaddr + epc); // Read the instruction from memory
        // uint64 instr = (uint64 *) walkaddr(p->pagetable, addr);
        char ch;
        int x = copyin(p->pagetable, &ch, epc, 4);
        if (x != 0 ) {
            kill(p->pid);
        }
        uint32 instr = *((uint32 *) (&ch));

        op = instr & 0x7f;
        rd = (instr >> 7) & 0x1F;
        funct3 = (instr >> 12) & 0x7;
        rs1 = (instr >> 15) & 0x1F;
        uimm = (instr >> 20) & 0xFFF;

        printf("(PI at %p) op = %x, rd = %x, funct3 = %x, rs1 = %x, uimm = %x\n", 
                addr, op, rd, funct3, rs1, uimm);

        // Decode the instruction based on the opcode and funct3 fields
        switch (op) {
            case 0b1110011: // Privileged instruction
                if (instr == 0x10200073) {
                    if (current_mode <= S_MODE) { // s-ret instruction
                        current_mode = U_MODE;
                        // set m status to u mode 
                        // check spie bit in sstatus and set to mie bit in mstatus
                        uint64 sstatus = vm_csr[0x100].val & (~(SSTATUS_SIE | SSTATUS_SPIE));
                        uint64 mstatus = sstatus & vm_csr[0x300].val;
                        vm_csr[0x100].val = sstatus;
                        vm_csr[0x300].val = mstatus;
                    } else {
                        kill(p->pid);
                    }
                } else if (instr == 0x30200073) { // m-ret instruction
                    if (current_mode <= M_MODE) {
                        current_mode = S_MODE;
                        // Clear MPP and MIE bits
                        uint64 mstatus = vm_csr[0x300].val & (~(MSTATUS_MPP_M | MSTATUS_MIE)) ;
                        vm_csr[0x300].val = mstatus;
                    } else {
                        kill(p->pid);
                    }
                } else if (rd == 0x0 && current_mode <= vm_csr[uimm].mode) { // CSR Write 
                    vm_csr[uimm].val = rs1;
                    if (uimm == 0xF11) {
                        if (vm_csr[0xF11].val == 0x0) {
                            kill(p->pid);
                        }
                    }
                } else if (rs1 == 0x0 && current_mode <= vm_csr[uimm].mode) { // CSR Read
                    switch (rd)
                    {
                    case 0xa:
                        p->trapframe->a0 = vm_csr[uimm].val;
                        break;
                    case 0xb:
                        p->trapframe->a1 = vm_csr[uimm].val;
                        break;
                    case 0xc:
                        p->trapframe->a2 = vm_csr[uimm].val;
                        break;
                    case 0xd:
                        p->trapframe->a3 = vm_csr[uimm].val;
                        break;
                    case 0xe:
                        p->trapframe->a4 = vm_csr[uimm].val;
                        break;
                    case 0xf:
                        p->trapframe->a5 = vm_csr[uimm].val;
                        break;
                    default:
                        break;
                    }
                }
                break;
                
                // switch (funct3) {
                //     case 0b010: // CSRW
                //         printf("CSRW instruction\n");
                //         break;
                //     case 0b111: // CSRR
                //         printf("CSRR instruction\n");
                //         break;
                //     case 0b000: // SRET or MRET
                //         if ((instr & 0xfff00000) == 0x10200000) {
                //             printf("SRET instruction\n");
                //         } else if ((instr & 0xfff00000) == 0x30200000) {
                //             printf("MRET instruction\n");
                //         } else {
                //             printf("Unknown privileged instruction\n");
                //         }
                //         break;
                //     default:
                //         printf("Unknown privileged instruction\n");
                //         break;
                // }
            // Add more cases for other instructions as needed
            default:
                printf("Unknown instruction\n");
                kill (p->pid);
                break;
        }
    } else {
        // If invalid exit the vm
        printf("INvalid SCAUSE\n");
        kill(p->pid);
        return;
    }
    // valid

    // depending on instruction => update the state => return result

    /* Print the statement */
    // printf("(PI at %p) op = %x, rd = %x, funct3 = %x, rs1 = %x, uimm = %x\n", 
                // addr, op, rd, funct3, rs1, uimm);
}


void trap_and_emulate_init(void) {
    /* Create and initialize all state for the VM */
    // register_states.
    for (int i=0; i<sizeof(u_reg_csr)/sizeof(int); i++) {
        vm_csr[u_reg_csr[i]].code = u_reg_csr[i];
        vm_csr[u_reg_csr[i]].mode = U_MODE;
        vm_csr[u_reg_csr[i]].val = 0;
    }

    for (int i=0; i<sizeof(m_reg_csr)/sizeof(int); i++) {
        vm_csr[m_reg_csr[i]].code = m_reg_csr[i];
        vm_csr[m_reg_csr[i]].mode = M_MODE;
        vm_csr[m_reg_csr[i]].val = 0;
    }

    for (int i=0; i<sizeof(s_reg_csr)/sizeof(int); i++) {
        vm_csr[s_reg_csr[i]].code = s_reg_csr[i];
        vm_csr[s_reg_csr[i]].mode = S_MODE;
        vm_csr[s_reg_csr[i]].val = 0;
    }

    vm_csr[0xF11].val = 0xC5E536;
}