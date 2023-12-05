/* These files have been taken from the open-source xv6 Operating System codebase (MIT License).  */
/* Modifications made by Adil Ahmad. */

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"
#include "buf.h"

void main();
void timerinit();

// entry.S needs one stack per CPU.
__attribute__ ((aligned (16))) char bl_stack[STSIZE * NCPU];

// Task: Collect and store hardware information
struct sys_info {
  // HW info collected from CPU registers
  uint64 vendor;
  uint64 arch;
  uint64 impl;

  // Bootloader binary addresses
  uint64 bl_start;
  uint64 bl_end;

  // Accessible DRAM addresses
  uint64 dr_start;
  uint64 dr_end;
};
struct sys_info* sys_info_ptr;

extern void _entry(void);

// entry.S jumps here in machine mode on stack0.
void
start()
{
  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
  w_tp(id);

  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
  x &= ~MSTATUS_MPP_MASK;
  x |= MSTATUS_MPP_S;
  w_mstatus(x);

  // disable paging for now.
  w_satp(0);

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
  w_mideleg(0xffff);
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);

  //base address (80000000) plus 117 MB (7500000)
  w_pmpaddr0((0x80000000 + 0x7500000) >> 2); 
  w_pmpcfg0(0xF);

  // CSE 536: Task 2.5
  // Load the kernel binary to its correct location
  uint64 kernel_entry_addr = 0;
  uint64 kernel_load_addr  = 0;
  uint64 kernel_size       = 0;

  // CSE 536: Task 2.5.1
  // Find the loading address of the kernel binary
  kernel_load_addr  = find_kernel_load_addr();

  // CSE 536: Task 2.5.2
  // Find the kernel binary size and copy it to the load address
  kernel_size       = find_kernel_size();

  // CSE 536: Task 2.5.3
  // Find the entry address and write it to mepc
  kernel_entry_addr = find_kernel_entry_addr();

  // CSE 536: Task 2.6
  // Provide system information to the kernel

  // CSE 536: Task 2.5.3
  // Jump to the OS kernel code
}