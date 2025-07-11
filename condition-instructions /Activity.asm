; Program 1: Generate even numbers from 1 to 20

section .data
    newline db 10

section .bss
    tmp resb 1

section .text
    global _start

_start:
    mov eax, 1      ; start from 1

print_loop:
    cmp eax, 21     ; stop at 20
    jge done

    mov ebx, eax    ; backup current number
    mov edx, 0
    mov ecx, 2
    div ecx         ; divide by 2 -> check even
    cmp edx, 0
    jne skip_print  ; if not even, skip

    mov eax, ebx    ; restore original number
    add al, '0'     ; convert to ASCII
    mov [tmp], al

    mov eax, 4
    mov ebx, 1
    mov ecx, tmp
    mov edx, 1
    int 0x80

    ; print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

skip_print:
    inc eax
    jmp print_loop

done:
    mov eax, 1
    int 0x80


; Uploaded a photo for flow logic.
;=========================================================================
;Program 2: Find largest among 5 numbers

section .data
    num1 dd 12
    num2 dd 48
    num3 dd 7
    num4 dd 33
    num5 dd 25

section .bss
    largest resd 1

section .text
    global _start

_start:
    mov eax, [num1]

    cmp eax, [num2]
    jg check3
    mov eax, [num2]

check3:
    cmp eax, [num3]
    jg check4
    mov eax, [num3]

check4:
    cmp eax, [num4]
    jg check5
    mov eax, [num4]

check5:
    cmp eax, [num5]
    jg store
    mov eax, [num5]

store:
    mov [largest], eax
    mov eax, 1
    int 0x80


;Start
;Initialize EAX with num1
;Compare EAX to num2
;If EAX > num2: keep EAX
;Else: move num2 into EAX
;Compare EAX to num3
;If EAX > num3: keep EAX
;Else: move num3 into EAX
;Compare EAX to num4
;If EAX > num4: keep EAX
;Else: move num4 into EAX
;Compare EAX to num5
;If EAX > num5: keep EAX
;Else: move num5 into EAX
;Store EAX in [largest]
;Exit


;======================================

;One of the biggest challenges I faced was just figuring out how to break the problem into smaller steps that I could code in assembly. I’m still getting used ;to the syntax and how everything needs to be done through registers. It was also hard at first to figure out how to compare values and store the largest one ;without messing something up. I had to go back to the examples from class a few times and test different things in GDB to see what was going on. It took me a ;bit to get the logic to work, especially making sure the right number was stored at the end. But once I got more comfortable reading the comparisons and ;jumps, it started to make more sense.






