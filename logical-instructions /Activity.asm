;Start
;Read assignment task
;Break each equation into logic operations
;Choose correct registers and instructions
;Write .asm code using NASM syntax
;Separate each equation into a different file
;Use gdb to test:
;Watch variables
;Step through line by line
;Fix errors if output is wrong
;Verify result is stored correctly
;Repeat for each part (XOR, TEST, etc.)
;End
;==========================================

;One of the main challenges during this lab was managing register sizes and making sure they ;matched the data types. Debugging division instructions was tricky at first, especially ;needing to clear 'edx' before using 'div'. Additionally, learning to step through code in gdb ;and monitor variables helped catch logical errors. Understanding how 'TEST' works without ;modifying operands was also key to implementing condition checks properly.


;===============================
section .text
        global _start

_start:
        mov eax,10
        xor eax,eax
        mov eax,1
        int 0x80

;===================

section .text
        global _start

_start:
        mov eax,8
        test eax,1              
        jz evnn                                        
        mov eax,'n'       
        mov [result],eax        
        mov eax,1
        int 0x80

evnn:
        mov eax,'y'     
        mov [result],eax
        mov eax,1
        int 0x80

segment .bss
        result resb 1
