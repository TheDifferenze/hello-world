;Midterm
; Calculates: result = (var1 + 2) / (var3 – var2)
; Expected result with var1=8, var2=2, var3=4 --> 5

section .data
    var1    dd  8
    var2    dd  2
    var3    dd  4
    msg     db "The result is: ", 0
    msg_len equ $ - msg
    nl      db 10

section .bss
    result  resd 1
    buf     resb 12            ; simple buffer for numbe

section .text
    global _start

_start:
    ;  (var1 + 2)
    mov     eax, [var1]
    add     eax, 2
    mov     ebx, eax           ; save numeratir

    ; (var3 – var2)
    mov     eax, [var3]
    sub     eax, [var2]
    mov     ecx, eax           ; denominator

    ; division: EDX:EAX / ECX from lectur
    mov     eax, ebx           ; dividend
    cdq                         ; sign‑extend into EDX
    idiv    ecx                ; quotient→EAX, remainder→EDX
    mov     [result], eax

    ; print label
    mov     eax, 4             ; sys_write
    mov     ebx, 1             ; stdout
    mov     ecx, msg
    mov     edx, msg_len
    int     0x80

    ; convert result to ASCII
    mov     eax, [result]
    mov     ecx, buf + 11      ; write digits right‑to‑left
    mov     byte [ecx], 0      ; null‑terminate
    dec     ecx

    cmp     eax, 0
    je      .put_zero

    mov     ebx, 10            ; divisor 10
.conv:
    xor     edx, edx           ; clear high part
    idiv    ebx                ; eax / 10
    add     dl, '0'
    mov     [ecx], dl
    dec     ecx
    cmp     eax, 0             ; more digits?
    je      .done_conv
    jmp     .conv

.put_zero:
    mov     byte [ecx], '0'

.done_conv:
    cmp     eax, 0             ; ensure ecx points to first digit
    inc     ecx                ; move to firt valid char

    ;print number
    mov     eax, 4
    mov     ebx, 1
    mov     edx, buf + 11
    sub     edx, ecx           ; length
    int     0x80

    ; newline
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, nl
    mov     edx, 1
    int     0x80

    ; exit(0)
    mov     eax, 1
    xor     ebx, ebx
    int     0x80


; Register name | Value
;  EAX (quotient)  | 5
;  EDX (remainder) | 0 


;2) | a | b | ab | a' b | a b' | Y | Truth Tavle
;| - | - | ---- | ---------- | --------- | ----- |
;| 0 | 0 | 0    | 0          | 0         | 0     |
;| 0 | 1 | 0    | 1          | 0         | 1     |
;| 1 | 0 | 0    | 0          | 1         | 1     |
;| 1 | 1 | 1    | 0          | 0         | 1     |

;       b         simplified K-map
;      0   1
;    +---+---+
; a 0| 0 | 1 |         Y = a + b
;    +---+---+
;   1| 1 | 1 |
;    +---+---+


;3) 


section .data
    number      dd  8
    odd_msg     db  "The number is odd", 10
    odd_len     equ $-odd_msg               ; 18
    even_msg    db  "The number is even", 10
    even_len    equ $-even_msg              ; 19

section .text
    global _start

_start:
    mov     eax, [number]      ; put the number in EAX

    test    eax, 1           ; check least-significant bit, sets ZF
    je      even                ; JE = jump if equal / zero

odd:                            ; odd branh
    mov     eax, 4           ; sys_write
    mov     ebx, 1         ; stdout
    mov     ecx, odd_msg
    mov     edx, odd_len
    int     0x80
    jmp     quit

even:                           ; even branch
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, even_msg
    mov     edx, even_len
    int     0x80

quit:                        ;exit
    mov     eax, 1           ;sys_exit
    xor     ebx, ebx            ; return 0
    int     0x80

;Load the number into EAX.

;TEST eax, 1 performs an implicit AND with 1 but doesn’t change EAX – it only sets flags.

;If the zero-flag is set (JE even) the number is even; otherwise it falls through to the odd branch.

;Each branch prints the appropriate message using Linux sys_write (int 0x80).





