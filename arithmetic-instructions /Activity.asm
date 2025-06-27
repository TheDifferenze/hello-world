;Start
; ↓
;Initialize variables in .data segment
;  ↓
;Write code in .text using basic instructions:
;  - mov to load values
;  - add, sub, mul, div for arithmetic
;  ↓
;Use gdb with:
;  - layout asm, layout regs, watch (int) result, stepi
; ↓
;Check register values after each step
; ↓
;Fix errors or logical bugs if result is wrong
;  ↓
;Save and test each equation in separate .asm files


;========================
;1)

section .data
    var1 dd 4        ; example value
    ten  dd 10

section .bss
    result resd 1

section .text
    global _start

_start:
    mov eax, [var1]
    neg eax             ; eax = -var1
    imul eax, [ten]     ; eax = -var1 * 10
    mov [result], eax
    mov eax, 1
    int 0x80
;====================================================
;One challenge was ensuring the correct use of instructions like mul and handling data types ;correctly. Since mul assumes the operand in eax, I had to be careful with register usage. ;Debugging in gdb also took some time to get used to, especially stepping through instructions ;and watching variables update in real-time. I also had to look up how to get a negative ;number. I didnt see this in the lectures, perhaps i missed it but I just ended up looking it ;up. 

;=======================================
;2) 
section .data
    var1 dd 1
    var2 dd 2
    var3 dd 3
    var4 dd 4

section .bss
    result resd 1

section .text
    global _start

_start:
    mov eax, [var1]
    add eax, [var2]
    add eax, [var3]
    add eax, [var4]
    mov [result], eax
    mov eax, 1
    int 0x80

;3)=======================

section .data
    var1 dd 2
    var2 dd 5
    var3 dd 6

section .bss
    result resd 1

section .text
    global _start

_start:
    mov eax, [var1]
    neg eax
    imul eax, [var2]    ; eax = -var1 * var2
    add eax, [var3]     ; eax = (-var1 * var2) + var3
    mov [result], eax
    
  mov eax, 1
  int 0x80



;4) ================================

section .data
    var1 dd 6           ; pick so that division is whole
    var2 dd 5           ; var2 - 3 = 2
    two  dd 2

section .bss
    result resd 1

section .text
    global _start

_start:
    mov eax, [var1]
    imul eax, [two]     ; eax = var1 * 2
    mov edx, 0          ; clear edx for division
    mov ebx, [var2]
    sub ebx, 3          ; ebx = var2 - 3
    div ebx             ; eax = eax / ebx
    mov [result], eax

    mov eax, 1
    int 0x80
