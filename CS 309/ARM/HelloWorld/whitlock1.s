@ File:    whitlock1.s
@ Author:  Sam Caleb Whitlock
@ Purpose: Print simple strings as an introduction to ARM assembly
@ Credit:  R. Kevin Preston for initial template
@ History: 
@    22-Feb-2026 Updated from template form to match assignment requirements
@    04-Mar-2019 Added comments to help with printf and svc calls.
@    15-Sep-2019 Added comments on which registers are changed
@                when there is a call to printf or SVC.
@    21-Jan-2026 Changed to match new ARM Assembly code template (ARMtemplate.s).
@
@ These commands assemble, link, run and debug the code.
@ Student should change the following to match their code filename. 
@
@ 
@ The following commands have been adjusted to match the name of the file
@ gcc whitlock1.s -g -c -o whitlock1.o
@ gcc whitlock1.o -g -o whitlock1
@ ./whitlock1
@ gdb --args ./whitlock1
@
@ In debug use the following when starting:
@ start
@ layout split
@ layout reg
@
@
@ If you get an error from the first gcc command AND it does not call out a line
@ number, check to make sure the current default directory contains the file.
@
@ If your codes executes with no errors but your string is not printing then
@ you have forgotten to end your string with \n. 
@

@ ************
@ The = (equal sign) is used in the ARM Assembler to get the address of a
@ label declared in the .data section. This takes the place of the ADR
@ instruction used in the textbook. 
@ ************

.global main 
main:        @Must use this label where to start executing the code. 

@  Save return to OS on stack.
PUSH {lr}

@ Part 1 - Print hello world message using the system call.
@
@ Use system call to write string to the STDIO
@   r0 - Must contain 1 to output to the standard output device (screen).
@   r1 - Must contain the starting address of the string to be printed. The string
@        has to comply with C coding standards. The string must be declared as a
@        .asciz so that it termimates with a \0 (null) character. 
@   r2 - Length of the string to be printed.
@   r7 - Must contain a 4 to write. 

    MOV   r7, #0x04    @ A 4 is a write command and has to be in r7.
    MOV   r0, #0x01    @ 01 is the STD (standard) output device. 
    MOV   r2, #19      @ Length of string to print (in Hex).
    LDR   r1, =string1 @ Put address of the start of the string in r1
    SVC   0            @ Do the system call

@ When using this method to print to the screen none of the registers
@ (r0 - r15) are changed. 

@ Use the C library call printf to print the second string. Details on 
@ how to use this function is given in the .data section. 
@
@   r0 - Must contain the starting address of the string to be printed. 
@

@ Using the printf C++ function to print out my email in string 2
    LDR  r0, =string2 @ Put address of string in r0
    BL   printf       @ Make the call to printf

@ Using a system call to print my sentence with my term in it from string3
    MOV   r7, #0x04    @ A 4 is a write command and has to be in r7.
    MOV   r0, #0x01    @ 01 is the STD (standard) output device. 
    MOV   r2, #57      @ Length of string to print (in Hex).
    LDR   r1, =string3 @ Put address of the start of the string in r1
    SVC   0            @ Do the system call


@ Return to the OS
POP {pc}

@ Declare the stings

@ A string for the first requirement: my full name, Sam Caleb Whitlock
.data       @ Lets the OS know it is OK to write to this area of memory. 
.balign 4   @ Force a word boundry.
string1: .asciz "Sam Caleb Whitlock\n"  @Length 19

@ A string for the second requirement: my email, scw0035@uah.edu
.balign 4   @ Force a word boundry
string2: .asciz "scw0035@uah.edu\n" @Length 16

@ A string that holds the third requirement: my term, CS308-01 2026
.balign 4   @ Force a word boundry
string3: .asciz "This is my first ARM Assembly program for CS309-01 2026.\n" @Length 57

.global printf
@  To use printf:
@     r0 - Contains the starting address of the string to be printed. The string
@          must conform to the C coding standards.
@     r1 - If the string contains an output parameter i.e., %d, %c, etc. register
@          r1 must contain the value to be printed. 
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed. 

@end of code and end of file. Leave a blank line after this. 
