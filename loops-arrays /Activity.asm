
;Part 1:

section .text
        global _start

_start:
        mov ebx,10	;ecx is a counter register
        label:
        loop label

        mov eax,1
        int 0x80


;When I replaced ECX with EBX in the code that used the loop instruction, 
;it didn’t work the way I expected. I thought changing the register would 
;make EBX act as the counter, but it turns out the loop instruction only works 
;with ECX. So even though I set EBX to 10, the program didn’t use it to control 
;the loop. Instead, it either did nothing or kept running forever, depending on 
;what ECX was. I realized that if I want to use EBX as a counter, I need to write 
;my own loop using dec and cmp instructions, along with a jump like jne.


;==============================================
;Part2

section .text
    global _start

_start:
    ; Initialize Fibonacci base values
    mov eax, 0      ; F(n-2) = 0
    mov ebx, 1     ; F(n-1) = 1 if I understand it right
    mov ecx, 9      ; Loop 9 times to compute F10 (since F0 and F1 are already set)

fibonacci_loop:
    mov edx, ebx     ; Copy current F(n-1) into EDX
    add ebx, eax    ; EBX = F(n) = F(n-1) + F(n-2)
    mov eax, edx    ; EAX = previous F(n-1) I think

    loop fibonacci_loop

    ; At this point, EBX = 55 (F10)

    ; Exit
    mov eax, 1      ; syscall: sys_exit
    xor ebx, ebx    ; exit code 0
    int 0x80

;=========================================

; Part 3

section .data
    array dd 7, 19, 12     ; Define an array of 3 integers

section .bss
    largest resd 1         ; Variable to store the largest number

section .text
    global _start

_start:
    mov esi, array         ; Load base address of array into ESI
    mov eax, [esi]       ; Load first element into EAX
    add esi, 4             ; Move to second element

    mov ebx, [esi]         ; Load second element into EBX
    cmp eax, ebx
    jge skip1
    mov eax, ebx           ; EAX holds larger between first two
skip1:
    add esi, 4             ; Move to third element

    mov ebx, [esi]         ; Load third element into EBX
    cmp eax, ebx
    jge skip2
    mov eax, ebx           ; EAX is now the largest
skip2:
    mov [largest], eax     ; Store largest value in memory

    ; Exit
    mov eax, 1             ; syscall: sys_exit
    xor ebx, ebx           ; exit code 0
    int 0x80

;==========================================

;One of the biggest challenges I faced in this lab was understanding how to 
;control the flow of the program using registers. For the first task, where 
;I had to use the EBX register as a counter, I initially tried to use the loop 
;instruction with EBX, but later found out that loop only works with ECX. This 
;caused confusion and took me a while to fix by writing a manual loop using dec and cmp.

;For the Fibonacci program, it was tricky to figure out how to store and update 
;the two previous numbers at each step. I had to carefully track which register 
;held which value (like eax, ebx, and edx) and kept messing up the order at first. 
;Getting the loop count right to reach the 10th Fibonacci number (which is 55) was 
;also harder than expected since the first two values (0 and 1) aren't really calculated inside the loop.

;Finally, for the array program, the hardest part was figuring out how to move through 
;the array using memory addresses and pointer logic with the ESI register. I also made a 
;few mistakes comparing and updating values to find the largest one, like forgetting to 
;add 4 bytes between elements. Overall, working with low-level instructions, managing 
;memory, and keeping track of register values was a challenge, but it helped me understand 
;how assembly really works under the hood.

