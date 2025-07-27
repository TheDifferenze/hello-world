SECTION .data
    filename db 'quotes.txt', 0          ; File name
    initial_content db 'To be, or not to be, that is the question.', 10, \
                        'A fool thinks himself to be wise, but a wise man knows himself to be a fool.', 10
    len_initial_content equ $ - initial_content

    append_content db 'Better three hours too soon than a minute too late.', 10, \
                      'No legacy is so rich as honesty.', 10
    len_append_content equ $ - append_content

SECTION .bss
    fd_quotes resd 1     ; Reserve space for file descriptor

SECTION .text
    global _start

_start:
    ;  Create"quotes.txt"
    mov eax, 8                  ; sys_creat
    mov ebx, filename           ; filename
    mov ecx, 0777o              ;permissions (read/write/execute for all)
    int 0x80
    mov [fd_quotes], eax         ; store file descriptor

    ; write initial quotes
    mov eax, 4                  ; sys_write
    mov ebx, [fd_quotes]        ; file descriptor
    mov ecx, initial_content    ; buffer with quotes
    mov edx, len_initial_content ; length
    int 0x80

    ; Close file 
    mov eax, 6                  ; sys_close
    mov ebx, [fd_quotes]
    int 0x80

    ; Reopen file for appending
    mov eax, 5                  ; sys_open
    mov ebx, filename
    mov ecx, 1                  ; O_WRONLY
    mov edx, 0                  ; mode (not needed for open) took a while to understand this
    int 0x80
    mov [fd_quotes], eax

    ; Seek to end
    mov eax, 19                  ;sys_lseek
    mov ebx, [fd_quotes]
    mov ecx, 0                  ; offset
    mov edx, 2                  ; SEEK_END
    int 0x80

    ;Write appended quotes
    mov eax, 4                  ; sys_write
    mov ebx, [fd_quotes]
    mov ecx, append_content
    mov edx, len_append_content
    int 0x80

    ;Close file again
    mov eax, 6
    mov ebx, [fd_quotes]
    int 0x80

    ;Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

;======================

;One of the main challenges I faced during the lab was understanding how system calls 
;work in assembly language, especially when working with file operations like creating, 
;writing, and appending. Since assembly is very low-level, every step had to be done 
;manually and carefully, which made debugging difficult when something went wrong. It 
;was also a bit confusing to keep track of which registers were used for which purpose. 
;However, going through the process helped me learn how important it is to follow the 
;correct sequence and be precise with syntax and memory references. Also referencing th 
;lecture for the week helped a lot.

