section .text
    global _start

_start:
    ; Assign values to x, y, z
    mov eax, 30
    push eax             ;z
    mov eax, 20
    push eax            ;y
    mov eax, 10
    push eax            ; x

    ; Call function
    call add_three_variables

    ; Clean up arguments from the stack (3 DWORDs = 12 bytes)
    add esp, 12

    ; Store the returned result (in EAX) to memory
    mov [result], eax

    ; Exit
    mov eax, 1          ; sys_exit
    int 0x80

; Function to add three integers
add_three_variables:
    push ebp            ; Save caller base pointer
    mov ebp, esp        ; Set base pointer for current stack frame

    ; Access x, y, z on the stack
    mov eax, [ebp + 8]  ; x
    add eax, [ebp + 12] ; x + y
    add eax, [ebp + 16] ; x + y + z

    mov esp, ebp        ;restore stack pointer
    pop ebp             ; restore base pointer
    ret                 ; Return (result in EAX)

section .bss
    result resd 1       ; reserve 4 bytes for the result


;==================== additional comments

;I am unsure if this is supposed to print anything to screen. The quiz doesnt explicityly state this so I am going to assume we dont need to do it. 
