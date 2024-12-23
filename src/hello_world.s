.global _main
.align 2

.EQU STDOUT, 1

// Syscalls
.EQU SYS_EXIT,  1
.EQU SYS_WRITE, 4



_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp


    adr x0, text
    bl strlen

    mov x2, x0
    mov x0, #STDOUT
    adr x1, text
    mov x16, #SYS_WRITE
    svc 0x80

    bl exit

    mov sp, x29
    ldp x29, x30, [sp], #16
    ret


// Args:
//     - x0 register = string pointer
// Return:
//     - x0 register = length of string
strlen:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov x1, x0 // String pointer
    mov x2, #0 // Length of string
strlenL0:
    ldrb w3, [x1]
    cbz w3, strlenL1
    add x1, x1, #1
    add x2, x2, #1
    b strlenL0

strlenL1:
    mov x0, x2

    mov sp, x29
    ldp x29, x30, [sp], #16
    ret

// Args: 
//     - x0 register = exit code
exit:
    mov x16, #SYS_EXIT
    svc 0x80


text: .ascii "Hello World!\n\0"