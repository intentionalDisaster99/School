@ Filename:   lab4.s
@ Author:     Sam Whitlock
@ Email:      scw0035@uah.edu
@ Class Term: CS309-01 2026
@ Purpose:    Show that I have learned the basics of ARM Assembly
@             including output, input, comparisons, arithmetic, 
@             and loops
@
@ Credit:  R. Kevin Preston for initial template
@ 
@ History: 
@    Date       Purpose of change
@    ----       ----------------- 
@  24-Mar-2026  Updated to match assignment criteria.
@   4-Jul-2019  Changed this code from using the stack pointer to a 
@               locally declared variable. 
@  15-Sep-2019  Moved some code around to make it clearer on how to 
@               get the input value into a register. 
@   1-Oct-2019  Added code to check for user input errors from the 
@               scanf call.   
@  21-Feb-2019  Added comments about "%c" vs " %c" related to scanf.
@   1-Oct-2025  Added -g to assembly command. Added note about editing
@               this file.
@   21-Jan-2026 Change this file to match the new ARMTemplate.s file
@
@ These commands assemble, link, run and debug the code.
@ gcc lab4.s -g -c -o lab4.o
@ gcc lab4.o -g -o lab4
@ ./lab4
@ gdb --args ./lab4 
@
@ In debug use the following when starting:
@ start
@ layout split
@ layout reg
@
@
@*******************************************************************
@ NOTE - Only edit this file on a Raspberry Pi using the Mousepad 
@        Text editor. Editing this file under Window, Google, 
@        Mac, etc. Can cause impedded characters to be added and 
@        will make this file incompatable with the assembler. 
@*******************************************************************
@
@***********************************************************************
@ The = (equal sign) is used in the ARM Assembler to get the address of a
@ label declared in the .data section. This takes the place of the ADR
@ instruction used in the textbook. 
@ ***********************************************************************

.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 

main:

@  Save return to OS on stack.
PUSH {lr}

@*******************
welcome:
@*******************
@ Simply prints the welcome message

   LDR r0, =welcomeMessage  @ Puts the message in r0 to be printed
   BL printf                @ Calls printf on the wrlcome message


@*******************
get_int:
@*******************
@ Gets the input value and stores it in r5
@ Note that it also catches errors and 
@ reruns until we get a good input

   LDR r0, =numInputPattern @ Setup to read in one number.
   LDR r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   BL  scanf                @ scan the keyboard.
   CMP r0, #READERROR       @ Check for a read error.
   BEQ readerror_int        @ If there was a read error go handle it. 
   LDR r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   LDR r5, [r1]             @ Read the contents of intInput and store in r5

@***********
print_input:
@***********
@ Prints the input out to the user

   LDR r0, =youEnteredMessage  @ Prepping to print the output format
   MOV r1, r5                  @ Prepping the input to be printed
   BL printf                   @ Actually printing

@***********
print_header:
@***********
@ Prints the header of the output table

   LDR r0, =tableHeader  @ Prepping to print the output format
   BL printf             @ Actually printing


@***********
print_table:
@***********
@ Prints the table
@ Register usage:
@    r5 target number of loops (already declared)
@    r6 loop counter
@    r7 current value of factorial

   MOV r6, #1    @ Setting up the loop counter
   MOV r7, #1    @ Setting up the starting factorial

@***********
print_table_row:
@***********
@ Calculates and prints the table row 
@ Register usage:
@    r5 target number of loops (already declared)
@    r6 loop counter
@    r7 current value of factorial

@ Printing the row 
   LDR r0, =tableRowBegin  @ Loading the first half of the row to print
   MOV r1, r6              @ Moving the loop counter to be printed
   BL printf               @ Printing it 
   LDR r0, =tableRowEnd    @ Loading the end of the row to be printed
   MOV r1, r7              @ Moving the factorial to be printed
   BL printf               @ Printing it

@ Incrememnting and checking if we are done
   ADD r6, r6, #1   @ Incrementing the counter
   CMP r6, r5       @ Checking to see if we need to exit
   BEQ exit         @ Exiting if we do

@ Calculating the next factorial and looping again
   MUL r7, r7, r6       @ Increasing the factorial
   B   print_table_row  @ Going on to the next row

@***********
readerror_int:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   LDR r0, =clearInputPattern
   LDR r1, =strInputError   @ Put address into r1 for read.
   BL scanf                 @ scan the keyboard.

@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.
@  First, though, we need to ask them to input the number again

   LDR r0, =reinputMessage @ Prepping to print
   BL printf               @ Printing

@  Back to the normal flow

   B get_int   @ Asking for the integer agian

@*******************
out_of_range_error:
@*******************
@ Prints out that they are out of the range and exits the program

   LDR r0, =outOfRangePrompt @ Loading the prompt to be printed
   BL  printf                @ Printing

@*******************
exit:
@*******************
@ End of the code. Force the exit and return control to OS

@ Return to the OS
POP {pc}

.data

@ Declare the strings and data needed

.balign 4
welcomeMessage: .asciz "This program will print the factorial of the integers from 1 to a number you enter. Please 
enter an integer number from 1 to 12 exclusive.\n\n"

.balign 4
reinputMessage: .asciz "We got an error on that input, unfortunately, please try again.\n\n"

.balign 4
outOfRangePrompt: .asciz "That number is out of range, unfortunately.\n\n Program terminating.\n"

.balign 4
youEnteredMessage: .asciz "You entered %d.\n\n"

.balign 4
tableHeader: .asciz "Number      n!" @ Note, there are 6 spaces here

.balign 4
tableRowBegin: .asciz "   \2d     " @ It is expected that tableRowEnd is printed directly after

.balign 4
tableRowEnd: .asciz "d\n"

@ Format pattern for scanf call.

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
charInputPattern: .asciz " %c"  @ character format for read.

.balign 4
clearInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ Used to clear the input buffer for invalid input. 

.balign 4
intInput: .word 0   @ Location used to store the inputted digit.

.balign 4
charInput: .word 0   @ Location used to store the inputted char.

@ Let the assembler know these are the C library functions. 

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

@ End of code and end of file. Leave a blank line after this.
