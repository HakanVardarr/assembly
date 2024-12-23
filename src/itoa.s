.global _main
.align 2

.EQU STDOUT, 1

// Syscalls
.EQU SYS_EXIT,  1
.EQU SYS_WRITE, 4

_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov w0, #-15212
    bl itoa

    sub sp, sp, 16
    str x0, [sp, #0] // String pointer

    bl strlen
    ldr x1, [sp]
    add sp, sp, 16

    mov x2, x0 // Length of string
    mov x0, #STDOUT
    mov x16, #SYS_WRITE
    svc 0x80

    bl exit

    mov sp, x29
    ldp x29, x30, [sp], #16
    ret

// Args:
//     - w0 register = int to convert to string
// Return:
//     - x0 register = string pointer
itoa:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    adrp x1, itoa_buffer@PAGE // Buffer pointer
    add x1, x1, itoa_buffer@PAGEOFF
    add x1, x1, #256
    strb wzr, [x1]

    sub x1, x1, #1
 
    mov w2, w0  // Number to convert
    mov w3, #10 // Divider
    mov w6, #0

    cbz w2, itoaL1
    cmp w2, #0
    b.gt itoaL2
    mov w6, #1
    mov w7, #-1
    mul w2, w2, w7

itoaL2:
    udiv w4, w2, w3
    mul w4, w4, w3
    sub w4, w2, w4
    add w4, w4, #'0'
    strb w4, [x1]
    sub x1, x1, #1
    udiv w2, w2, w3
    cbnz w2, itoaL2
    b itoaL3

itoaL1: 
    mov w3, #'0'
    strb w3, [x1]
    sub x1, x1, #1

itoaL3:
    cbz w6, itoaL5
    mov w3, #'-'
    strb w3, [x1]
    sub x1, x1, #1
    

itoaL5:


    add x1, x1, #1
    mov x0, x1
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


.data
    itoa_buffer: .space 256