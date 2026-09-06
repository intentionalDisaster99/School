@ File:    template.s
@ Author:  Sam Caleb Whitlock
@ Purpose: A simple hello world template so that I can copy it over to use as a basis for my labs. Copied from my CS 309 submissiosn
@

.global main 
main:        
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

.global scanf
@  To use scanf:
@      r0 - Contains the address of the input format string used to read the user
@           input value. In this example it is numInputPattern.  
@      r1 - Must contain the address where the input value is going to be stored.
@           In this example memory location intInput declared in the .data section
@           is being used.  
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed.
@ Important Notes about scanf:
@   If the user entered an input that does NOT conform to the input pattern, 
@   then register r0 will contain a 0. If it is a valid format
@   then r0 will contain a 1. The input buffer will NOT be cleared of the invalid
@   input so that needs to be cleared out before attempting anything else.
@
@ Additional notes about scanf and the input patterns:
@    1. If the pattern is %s or %c it is not possible for the user input to generate
@       and error code. Anything that can be typed by the user on the keyboard
@       will be accepted by these two input patterns. 
@    2. If the pattern is %d and the user input 12.123 scanf will accept the 12 as
@       valid input and leave the .123 in the input buffer. 
@    3. If the pattern is "%c" any white space characters are left in the input
@       buffer. In most cases user entered carrage return remains in the input buffer
@       and if you do another scanf with "%c" the carrage return will be returned. 
@       To ignore these "white" characters use " %c" as the input pattern. This will
@       ignore any of these non-printing characters the user may have entered.
@

@end of code and end of file. Leave a blank line after this. 
