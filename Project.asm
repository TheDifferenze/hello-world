; --------Part 1-----------
;1) XOR Encrypt/Decrypt → output.txt
;Start
;↓
;Load constants (plaintext, key, lengths)
;↓
;Set ECX=msg_len, ESI=plaintext, EDI=key, EDX=encrypted
;↓
;[Encrypt Loop]
;• AL ← [ESI]
;• AL ← AL XOR [EDI]
;• [EDX] ← AL
;• ESI++, EDI++, EDX++
;• ECX-- → if ECX ≠ 0, repeat
;↓
;Set ECX=msg_len, ESI=encrypted, EDI=key, EDX=decrypted
;↓
;[Decrypt Loop]
;• AL ← [ESI]
;• AL ← AL XOR [EDI]
;• [EDX] ← AL
;• ESI++, EDI++, EDX++
;• ECX-- → if ECX ≠ 0, repeat
;↓
;Create/Open “output.txt” (sys_creat)
;↓
;Write:
;• “Plain text: ” + plaintext + newline
;• “Key: ” + key + newline
;• “Encrypted text: ” + encrypted + newline
;• “Decrypted text: ” + decrypted + newline
;↓
;Close file (sys_close)
;↓
;Exit (sys_exit)


SECTION .data
    filename db 'output.txt', 0

    ; IMPORTANT: put msg_len right after plaintext
    plaintext db 'HELLO'
    msg_len   equ $ - plaintext

    key       db 'world'          ; same length as plaintext

    hdr_plain db 'Plain text: '
    hdr_plain_len equ $ - hdr_plain

    hdr_key   db 'Key: '
    hdr_key_len equ $ - hdr_key

    hdr_enc   db 'Encrypted text: '
    hdr_enc_len equ $ - hdr_enc

    hdr_dec   db 'Decrypted text: '
    hdr_dec_len equ $ - hdr_dec

    newline   db 10

SECTION .bss
    encrypted resb msg_len
    decrypted resb msg_len
    fd_out    resd 1

SECTION .text
    global _start

_start:
    ; Encrypt: encrypted[i] = plaintext[i] XOR key[i]
    mov ecx, msg_len
    mov esi, plaintext
    mov edi, key
    mov edx, encrypted
.enc_loop:
    mov al, [esi]
    xor al, [edi]
    mov [edx], al
    inc esi
    inc edi
    inc edx
    loop .enc_loop

    ; Decrypt: decrypted[i] = encrypted[i] XOR key[i]
    mov ecx, msg_len
    mov esi, encrypted
    mov edi, key
    mov edx, decrypted
.dec_loop:
    mov al, [esi]
    xor al, [edi]
    mov [edx], al
    inc esi
    inc edi
    inc edx
    loop .dec_loop

    ; creat(output.txt, 0777o)
    mov eax, 8
    mov ebx, filename
    mov ecx, 0777o
    int 0x80
    mov [fd_out], eax

    ; "Plain text: " + plaintext + \n
    mov eax, 4       ; sys_write
    mov ebx, [fd_out]
    mov ecx, hdr_plain
    mov edx, hdr_plain_len
    int 0x80

    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, plaintext
    mov edx, msg_len
    int 0x80

    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; "Key: " + key + \n
    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, hdr_key
    mov edx, hdr_key_len
    int 0x80

    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, key
    mov edx, msg_len
    int 0x80

    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; "Encrypted text: " + encrypted + \n
    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, hdr_enc
    mov edx, hdr_enc_len
    int 0x80

    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, encrypted
    mov edx, msg_len
    int 0x80

    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; "Decrypted text: " + decrypted + \n
    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, hdr_dec
    mov edx, hdr_dec_len
    int 0x80

    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, decrypted
    mov edx, msg_len
    int 0x80

    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; close + exit
    mov eax, 6
    mov ebx, [fd_out]
    int 0x80
    mov eax, 1
    xor ebx, ebx
    int 0x80

;---------Part 2---------

;2) Iterative Counter → counter_fun.txt
;Start
;↓
;Push 20000 and call count(n)
;↓
;[Function count(n)]
;• Prologue (save EBP)
;• ECX ← n
;• Loop: ECX-- → if ECX ≠ 0, repeat
;• Epilogue (restore EBP), return
;↓
;Open “counter_fun.txt” 
;↓
;Write: “Iterative Counter reached: ” + “20000” + newline
;↓
;Close file
;↓
;Exit

;' func_counter.asm — Iterative version
; run  : (time ./func_counter) 2>> counter_fun.txt

SECTION .data
    filename db "counter_fun.txt",0
    hdr      db "Iterative Counter reached: "
    hdr_len  equ $-hdr
    num      db "20000"
    num_len  equ $-num
    nl       db 10

SECTION .text
    global _start

count:
    push ebp
    mov  ebp, esp
    mov  ecx, [ebp+8]
.loop:
    dec  ecx
    jnz  .loop
    mov  esp, ebp
    pop  ebp
    ret

_start:
    ; call count(20000)
    push dword 20000
    call count
    add  esp, 4

    ; open file counter_fun.txt
    mov eax, 5            ; sys_open
    mov ebx, filename     ; filename
    mov ecx, 0x441        ; flags
    mov edx, 0644         ; mode
    int 0x80
    mov esi, eax          ; save file descriptor in esi

    ; write header
    mov eax, 4
    mov ebx, esi
    mov ecx, hdr
    mov edx, hdr_len
    int 0x80

    ; write number
    mov eax, 4
    mov ebx, esi
    mov ecx, num
    mov edx, num_len
    int 0x80

    ; write newline
    mov eax, 4
    mov ebx, esi
    mov ecx, nl
    mov edx, 1
    int 0x80

    ; close file
    mov eax, 6
    mov ebx, esi
    int 0x80

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

;-------------------------------

;2) func_recursive.asm — Recursive version
; run  : (time ./func_recursive) 2>> counter_rec.txt

; Recursive Counter → counter_rec.txt
;Start
;↓
;Push 20000 and call count_rec(n)
;↓
;[Function count_rec(n)]
;• Prologue (save EBP)
;• EAX ← n
;• Decision: EAX == 0 ?
;├─ Yes → return
;└─ No → (n-1): push (EAX-1), call count_rec again, then return
;↓
;Open “counter_rec.txt” 
;↓
;Write: “Recursive Counter reached: ” + “20000” + newline
;↓
;Close file
;↓
; Exit


SECTION .data
    filename db "counter_rec.txt",0
    hdr      db "Recursive Counter reached: "
    hdr_len  equ $-hdr
    num      db "20000"
    num_len  equ $-num
    nl       db 10

SECTION .text
    global _start

count_rec:
    push ebp
    mov  ebp, esp
    mov  eax, [ebp+8]
    cmp  eax, 0
    je   .done
    dec  eax
    push eax
    call count_rec
    add  esp, 4
.done:
    mov  esp, ebp
    pop  ebp
    ret

_start:
    ; call count_rec(20000)
    push dword 20000
    call count_rec
    add  esp, 4

    ; open file counter_rec.txt
    mov eax, 5            ; sys_open
    mov ebx, filename     ; filename
    mov ecx, 0x441        ; flags
    mov edx, 0644         ; mode
    int 0x80
    mov esi, eax          ; save file descriptor

    ; write header
    mov eax, 4
    mov ebx, esi
    mov ecx, hdr
    mov edx, hdr_len
    int 0x80

    ; write number
    mov eax, 4
    mov ebx, esi
    mov ecx, num
    mov edx, num_len
    int 0x80

    ; write newline
    mov eax, 4
    mov ebx, esi
    mov ecx, nl
    mov edx, 1
    int 0x80

    ; close file
    mov eax, 6
    mov ebx, esi
    int 0x80

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80



