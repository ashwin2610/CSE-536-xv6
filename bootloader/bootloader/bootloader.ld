OUTPUT_ARCH( "riscv" )

ENTRY( _entry )

SECTIONS
{
  /* CSE 536: (Task 2.2) Ensure the correct entry address based on where -kernel in QEMU jumps. */
  . = 0x80000000;

  .text : { *(.text) }
  ecode = .;
  . = ALIGN(0x1000);

  .data : { *(.data) }
  edata = .;
  . = ALIGN(0x1000);

  .rodata : { *(.rodata) }
  erodata = .;
  . = ALIGN(0x1000);

  .bss : { *(.bss) }
  ebss = .;
  . = ALIGN(0xFF4);

  end  = .;
}
