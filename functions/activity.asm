section .data
    odd_message db "Odd", 10        ; "Odd" + newline
    odd_len equ $ - odd_message

    even_message db "Even", 10      ; "Even" + newline
    even_len equ $ - even_message

section .text
    global _start

_start:
    mov eax, 10               ;Assign a number to check (change this line test other numbers)
    push eax                  ;Pass the number to the fuction

    call check_parity       ;Call the function to check odd/even
    add esp, 4              ; Clean up the stack

    call exit              ; Exit program

check_parity:
    push ebp                ; Save base pointer
    mov ebp, esp             ; Create new stack frame

    mov eax, [ebp+8]         ; Get the number passed as argument

    test eax, 1            ; Check if LSB is 1 (odd) or 0 (even)
    jz is_even              ; Jump if even

    ;Print "Odd"
    mov eax, 4
    mov ebx, 1
    mov ecx, odd_message
    mov edx, odd_len
    int 0x80
    jmp end_check

is_even:
    ;print "Even"
    mov eax, 4
    mov ebx, 1
    mov ecx, even_message
    mov edx, even_len
    int 0x80

end_check:
    mov esp, ebp          ; Restore stack
    pop ebp
    ret

exit:
    mov eax, 1               ; sys_exit
    xor ebx, ebx              ; return code 0
    int 0x80

;==============================

;One of the challenges I faced during this lab was figuring out how to pass 
;a number to the function and properly access it from the stack. At first, I was 
;confused about how the `ebp` and `esp` registers work together in a function, 
;and I made mistakes trying to get the correct value from [ebp+8]. Another 
;part that was tricky was checking if the number was odd or even using bitwise 
;operations. I had to learn how the `test` instruction works to check the least 
;significant bit. I also struggled a bit with remembering to clean up the stack 
;after calling the function with add esp, 4, since forgetting that caused issues 
;in my earlier attempts. Overall, the hardest part was keeping track of how the 
;stack works during function calls, but doing this lab helped me understand that better.

