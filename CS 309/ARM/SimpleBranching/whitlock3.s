@ Filename:   whitlock3.s
@ Author:     Sam Whitlock
@ Email:      scw0035@uah.edu
@ Class Term: CS309-01 2026
@ Purpose:    Provide simple output based on an input as a way to learn  
@             conditional branching
@
@ Credit:  R. Kevin Preston for initial template
@ 
@ History: 
@    Date       Purpose of change
@    ----       ----------------- 
@  04-Mar-2026  Updated to match assignment criteria.
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
@ gcc whitlock3.s -g -c -o whitlock3.o
@ gcc whitlock3.o -g -o whitlock3
@ ./whitlock3
@ gdb --args ./whitlock3 
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
prompt_for_int:
@*******************

@ Ask the user to enter a number.
 
   ldr r0, =numInputPrompt @ Put the address of my string into the first parameter
   bl  printf              @ Call the C printf to display input prompt. 
   

@*******************
get_int:
@*******************

@ Set up r0 with the address of input pattern.
@ scanf puts the input value at the address stored in r1. We are going
@ to use the address for our declared variable in the data section - intInput. 
@ After the call to scanf the input is at the address pointed to by r1 which 
@ in this case will be intInput. 

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerror_int        @ If there was a read error go handle it. 
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1


@*******************
check_integer:
@*******************

@ Checks the inputted integer (currently in r1) to see if it is more or less than 100

   cmp r1, #100          @ Updates flags based on r1 - 100
   bpl greater_than_100    @ Jumps to greater than 100 if it is positive or zero

@*******************
less_than_100:
@*******************

   ldr r0, =lessThanStr    @ Moves the less string to be printed
   bl printf               @ Printing the character (note that some registers get cleared
                           @ but that isn't an issue because we are done with them now)
   b prompt_for_char       @ Skipping over the other case

@*******************
greater_than_100:
@*******************

   ldr r0, =greaterOrEqualStr @ Moves the greater than or equal string to be printed
   bl printf                  @ Printing the character (note that some registers get cleared
                              @ but that isn't an issue because we are done with them now)


@*******************
prompt_for_char:
@*******************

@ Ask the user to enter a character.
 
   ldr r0, =charInputPrompt @ Put the address of my string into the first parameter
   bl  printf               @ Call the C printf to display input prompt. 

@*******************
get_char:
@*******************

@ Set up r0 with the address of input pattern.
@ scanf puts the input value at the address stored in r1. We are going
@ to use the address for our declared variable in the data section - intInput. 
@ After the call to scanf the input is at the address pointed to by r1 which 
@ in this case will be intInput. 

   ldr r0, =charInputPattern @ Setup to read in one number.
   ldr r1, =charInput        @ load r1 with the address of where the
                             @ input value will be stored. 
   bl  scanf                 @ scan the keyboard.
   cmp r0, #READERROR        @ Check for a read error.
   beq readerror_char        @ If there was a read error go handle it. 
   ldr r1, =charInput        @ Have to reload r1 because it gets wiped out. 
   ldrb r1, [r1]             @ Read the contents of intInput and store in r1


@*******************
check_char:
@*******************

@ This one is not quite as simple. We need to have multiple conditions to check to see if it is in a certian range. 
@ As the characters are stored in ascii, we need to check to see if it is in [65, 90]
@ I might be able to do something silly and check the same range by subtracting by 32, though, because they are 32 apart

@ I am going to use a thing we havem't talked about yet, but is talks about it on the paper so I figued I'm okay
   bl check_range      @ Saves the current location and then checks the range
   cmp r7, #1          @ Checks to see if we found that it was lowercase (inside [65, 90])
   beq upper_case      @ Jumping to print out lowercase if it is lowercase
   
   sub r1, r1, #32     @ Uppercase and lowercase numbers are exactly 32 apart, so we can just check the range after subtracting 32
   bl check_range      @ Saves the current instruction and jumps to check the range 
   cmp r7, #1          @ Checks to see if we found that it was uppercase (now inside [65, 90])
   beq lower_case      @ Jumping to print out uppercase if it is uppercase

   b special_character @ If we get here, we can assume that it is a special character

@*******************
check_range:
@*******************

@ Checks what is in r1 to see if it is within the range [65, 90]
@ If it is within the range, it writes 1 to r7, otherwise a 0 to r7

@ Checking if it is higher than 65

@! This isn't working correctly, I think I just don't have a good understanding of the commands cmp and cmn

   cmp r1, #90       @ If it is higher than 90, then it is outside the range
   bpl outside       @ If it doesn't branch here, then it is inside and automatically flows into the inside function

   cmp r1, #65       @ If it is lower than 65, then it is outside
   bmi outside       @ Branching to be outside

@*******************
inside: 
@*******************

@ Saves in r7 that it is inside and jumps back to wherever BL was lasted called
   mov r7, #1
   bx lr

@*******************
outside: 
@*******************

@ Saves in r7 that it is outside and jumps back to wherever BL was lasted called
   mov r7, #0
   bx lr


@*******************
lower_case:
@*******************

@ Prints out that it is lowercase
   ldr r0, =lowerCaseStr    @ Put the address of my string into the first parameter
   bl  printf               @ Call the C printf to display input prompt. 
   b myexit

@*******************
upper_case:
@*******************

@ Prints out that it is lowercase
   ldr r0, =upperCaseStr    @ Put the address of my string into the first parameter
   bl  printf               @ Call the C printf to display input prompt. 
   b myexit

@*******************
special_character:
@*******************

@ Prints out that it was a special character
   ldr r0, =specialCharacterStr @ Put the address of my string into the first parameter
   bl  printf                   @ Call the C printf to display input prompt. 
   b myexit

@***********
readerror_char:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, =clearInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.

   b prompt_for_char  @ Prompting for the character again 

@***********
readerror_int:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, =clearInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.

   b prompt_for_int   @ Asking for the integer agian

@*******************
myexit:
@*******************
@ End of my code. Force the exit and return control to OS

@ Return to the OS
POP {pc}

.data

@ Declare the strings and data needed

.balign 4
numInputPrompt: .asciz "Input a number: \n"

.balign 4
charInputPrompt: .asciz "Input a character: \n"

.balign 4
greaterOrEqualStr: .asciz "The input number is greater than or equal to 100.\n"

.balign 4
lessThanStr: .asciz "The input number is less than 100.\n"

.balign 4
upperCaseStr: .asciz "Upper case letter entered.\n"

.balign 4
lowerCaseStr: .asciz "Lower case letter entered.\n"

.balign 4
specialCharacterStr: .asciz "Special character entered.\n"

@ Format pattern for scanf call.

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
charInputPattern: .asciz " %c"  @ character format for read.

.balign 4
clearInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 

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
