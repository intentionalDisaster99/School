@ File:    whitlock1.s
@ Author:  Sam Caleb Whitlock
@ Purpose: Show that I know how to use auto-indexing to access array elements and do nested subroutine calls
@ 
@ Notes:
@    I know I don't have to write what each label clobbers (especially those that don't push/pop the link register)
@    but I like it to help me keep track
@
@
@ These commands assemble, link, run and debug the code.
@ gcc whitlock1.s -g -c -whitlock1.o
@ gcc whitlock1.o -g -o whitlock1
@ ./whitlock1
@ gdb --args ./whitlock1 
@
@ In debug use the following when starting:
@ start
@ layout split
@ layout reg
@


.global main 
main:        
PUSH {lr}


printWelcomeMessage:
@ Prints a welcome message
@ Clobbers:
@   r0, r1, r2, r3, r12

    ldr  r0, =welcomeMessage
    bl   printf    

arrayTwoLoopStart:
@ Gets all of the inputs for arrayTwo
@ Clobbers:
@   r0, r1, r2, r3, r6, r7, r8, r12

    mov  r8, #10              @ The counter variable
    ldr  r7, =arrayTwo        @ Loading arrayTwo to be used
    add  r7, #40              @ Shifting 10 integers to the start of the blank area

arrayTwoLoopPoint:
@ Loops until the counter in r8 hits 20
@ Increments the number in [r7] and stores the incremented number in [r7, #1, #2]

    ldr  r0, =numPattern @ Loading the number output pattern for printf
    mov  r1, r8      @ Printing the index 
    bl   printf      @ that we are on
    ldr  r0, =colon  @ Printing a colon so  
    bl   printf      @ that it looks nice


    bl   get_int        @ Getting the input (will be put in r1)
    str  r5, [r7], #4   @ Storing the input at the next place (shifting twice because each int is 4 bytes)
    
    add  r8, #1               @ Incrememnting loop
    cmp  r8, #20              @ Checking to see if the loop is over
    beq  arrayThreeLoopStart
    b    arrayTwoLoopPoint    @ Otherwise looping back to the array loop

arrayThreeLoopStart:
@ Adds arrayOne to arrayTwo
@ Clobbers:
@    r5, r6, r7, r8, r9, r10

    mov  r8, #0           @ Loop variable
    ldr  r5, =arrayOne    @ Loading arrayOne for  
    ldr  r6, =arrayTwo    @ Loading arrayTwo for printing
    ldr  r7, =arrayThree  @ The array we need to modify

arrayThreeLoopPoint:

    ldr  r9, [r5], #4       @ The element from the first array (post-indexing by 4 bytes)
    ldr  r10, [r6], #4      @ The element from the second array (post-indexing by 4 bytes)

    add  r9, r9, r10        @ Adding together the two current elements  
    str  r9, [r7], #4       @ Saving the added elements into the current location in arrayThree

    add  r8, #1  @ Incrementing
    cmp  r8, #20 @ Checking if the loop is over
    bne  arrayThreeLoopPoint

printingArrays:
@ Prints the arrays (just calling the subroutines)
@ Clobbers
@   r0, r1, r2, r3, r7, r8, r12

    @ Printing the first array
    ldr  r0, =arrayIs   @ Prepping to print which one it is 
    mov  r1, #1
    bl   printf         @ Printing the name
    ldr  r7, =arrayOne
    bl   printArray
    ldr  r0, =newLine  @ Printing a new line so  
    bl   printf        @ you can tell what is what
 
    @ Printing the second array
    ldr  r0, =arrayIs   @ Prepping to print which one it is 
    mov  r1, #2
    bl   printf         @ Printing the name
    ldr  r7, =arrayTwo
    bl   printArray
    ldr  r0, =newLine  @ Printing a new line so  
    bl   printf        @ you can tell what is what
 
    @ Printing the sum array
    ldr  r0, =arrayIs   @ Prepping to print which one it is 
    mov  r1, #3
    bl   printf         @ Printing the name
    ldr  r7, =arrayThree
    bl   printArray
    ldr  r0, =newLine  @ Printing a new line so  
    bl   printf        @ you can tell what is what

@ Return to the OS
POP {pc}




@@@@@@@@@@@@@@@@
@ Subroutines
@@@@@@@@@@@@@@@@


get_int:
@ Set up r0 with the address of input pattern.
@ scanf puts the inputed value at the address stored in r1
@ Clobbers:
@   r0, r1, r2, r3, r12

    push {lr}

    ldr r0, =numPattern @ Setup to read in one number.
    ldr r1, =intInput        @ load r1 with the address of where the
                             @ input value will be stored. 
    bl  scanf                @ scan the keyboard.
    LDR r1, =intInput        @ Have to reload r1 because it gets wiped out. 
    LDR r5, [r1]             @ Read the contents of intInput and store in r5


    pop {pc}

printArray:
@ Prints an array starting at the address in r7
@ Assumes that the array has a length of 20
@ Clobbers
@ r0, r1, r2, r3, r8, r12

    push {lr}     @ Allowing me to return

    mov  r8, #0   @ Counter

printLoopPoint:

    ldr  r0, =numPattern @ Loading the number output pattern for printf
    ldr  r1, [r7, r8, LSL #2]    @ Accessing the element to be printed at the index r8
    add  r8, r8, #1        
    bl   printf
    ldr  r0, =space @ Printing a space so  
    bl   printf     @ you can tell what is what
    cmp  r8, #20      
    bne  printLoopPoint @ Continuing the loop if it isn't over

    pop  {pc}           @ Returning
   

@@@@@@@@@@@@@@@@
@ Variables
@@@@@@@@@@@@@@@@
.data

@ The welcome message
.balign 4
welcomeMessage: .asciz "Welcome!\n\nPlease insert 10 numbers to account for the second half of the second array.\nThe index will be printed for each one, starting at 10.\n"

@ The first array, completely initialized in the .data section
.balign 4 
arrayOne:   .word  0, 1, 2, 3, 4, 5, 6, -7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

@ The second array, half initialized here and half in using scanf
.balign 4 
arrayTwo:   .word  0, 1, -2, -4, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

@ The third array, completely initilzied with scanf (80 bytes so that we can have 20 4 byte integers)
.balign 4 
arrayThree: .space 80 

@ Just a new line so that I can make it pretty
.balign 4 
newLine: .asciz "\n" 

@ Another thing that is just to make the output prettier
.balign 4 
colon: .asciz ": " @ There really wasn't a better name, okay

@ Another thing that is just to make the output prettier
.balign 4 
space: .asciz " " @ There really wasn't a better name, okay

@ A string to introduce each of the arrays when I print them at the end
.balign 4 
arrayIs: .asciz "Array %d: "

@ The input that we are looking for for scanf for integers
.balign 4
numPattern: .asciz "%d"  

@ Pattern to clear the input buffer
.balign 4 
clearInputPattern: .asciz "%[^\n]" 

@ Location used to store inputted digit
.balign 4
intInput: .word 0 

@ User to clear the input buffer for invalid input. 
.balign 4
strInputError: .skip 100*4 



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

.global printf
@  To use printf:
@     r0 - Contains the starting address of the string to be printed. The string
@          must conform to the C coding standards.
@     r1 - If the string contains an output parameter i.e., %d, %c, etc. register
@          r1 must contain the value to be printed. 
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed. 

@end of code and end of file. Leave a blank line after this. 
