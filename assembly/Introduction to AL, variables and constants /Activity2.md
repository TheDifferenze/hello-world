1. Understand the Goal: Perform addition of two numbers using Assembly, storing the result.
2. Identify Components:
Two initialized variables (var1, var2).
One uninitialized variable (result).
Basic arithmetic operation (addition).
Program entry and exit points.
3. Choose Data Sections:
Initialized variables go into .data.
Uninitialized variables go into .bss.
Code goes into .text.
4. Determine Instructions:
mov to load values from memory into registers.
add to perform the addition using registers.
mov to store the result from a register back into memory.
System call for program exit.
5. Order of Operations:
Load var1 into a register (e.g., eax).
Load var2 into another register (e.g., ebx).
Add ebx to eax.
Store eax (the sum) into result.
Exit program.

============================================

Challenges in Performing the Lab
Syntax Specificity: Assembly language is very low-level and requires precise syntax for instructions, registers, and memory addressing. Small errors can prevent compilation or lead to unexpected behavior.This happened a lot to me.
Register Management: Understanding which registers to use (eax, ebx, etc.) and how they are affected by operations is crucial.
Memory Segmentation: Properly declaring variables in the .data (initialized) and .bss (uninitialized) sections and understanding their purpose.
Debugging: Identifying logical errors in Assembly code can be difficult without robust debugging tools like GDB, which allows examining registers and memory.
Compilation and Linking: The process of assembling the .asm file into an object file and then linking it into an executable can have specific command-line requirements.

============================================

section .text
        global _start

_start:
        ;use this space for the main body of your program
        ;======== write your code below ===========

        ; Assign 10 to var1
        mov eax, [var1]   ; Load the value of var1 (10) into EAX
        
        ; Assign 15 to var2
        mov ebx, [var2]   ; Load the value of var2 (15) into EBX

        ; Add var1 and var2 and save them into the result variable.
        add eax, ebx      ; Add the content of EBX (var2) to EAX (var1)
        mov [result], eax ; Store the sum from EAX into the 'result' variable
        ;======== write your code above ===========
        
        mov eax,1       ;set eax register to 1 (do not remove this line)
        int 0x80        ;interrupt 0x80 (do not remove this line)

segment .bss
        ;use this space for uninitialized variable (result)
        result resd 1
