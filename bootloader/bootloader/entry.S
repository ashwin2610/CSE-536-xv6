# _entry should be the first function invoked when
# the QEMU CPU starts executing. 

.section .text
.global _entry
_entry:
        la sp, bl_stack
        li a0, 4096
        add sp, sp, a0
        call start

.global spin
spin:
        j spin