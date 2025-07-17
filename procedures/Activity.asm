section .text
global _start

_start:
    mov eax, 65    ; start at A (ASCII 65)

print_loop:
    push eax       ; save curent letter

    mov [res], eax ; store letter in memory
    mov ecx, res   ; move address to ecx
    call output    ; print the lettr
    call linefeed  ;print a new line

    pop eax        ; restore letter

    inc eax         ; move to next letter
    cmp eax, 91     ; check if we passed Z (90)
    jl print_loop  ; if not, keep going

    call exit      ; end the program

output:
    mov eax, 4      ; sys_write
    mov ebx, 1      ; stdout
    mov edx, 1      ; print 1 byte
    int 0x80
    ret

linefeed:
    mov eax, 10    ;ASCII for newline
    mov [res], eax
    mov ecx, res
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    int 0x80
    ret

exit:
    mov eax, 1     ;sys_exit
    int 0x80
    ret

section .bss
res resb 1         ; space to store character

;=====================================

;One of the main challenges I had while doing this lab was understanding how to use system calls like 
;int 0x80 to actually print characters to the screen. At first, I wasn’t sure how the output and 
;linefeed parts worked together, and I was confused about why I needed to push and pop eax. It took 
;me some time to realize that system calls change the values in registers, so saving and restoring the 
;letter was important to keep the loop working right. Another thing I struggled with was keeping track
;of the ASCII values. I kept forgetting that `A` starts at 65 and that the loop had to stop at 91 to 
;include `Z`. Overall, getting the loop and procedures to work together was tricky at first, but once 
;I figured it out, it started to make more sense.

