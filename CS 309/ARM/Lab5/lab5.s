@ Filename:   lab5.s
@ Author:     Sam Whitlock
@ Email:      scw0035@uah.edu
@ Class Term: CS309-01 2026
@ Purpose:    Combine many of the things that I have learned about ARM
@             throughout this semester into a larger project, specifically
@             simulating a gas pump.
@
@ Credit:  R. Kevin Preston for initial template
@ 
@ History: 
@    Date       Purpose of change
@    ----       ----------------- 
@  08-Apr-2026  Updated to match assignment criteria.
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
@ gcc lab5.s -g -c -o lab5.o
@ gcc lab5.o -g -o lab5
@ ./lab5
@ gdb --args ./lab5 
@
@ In debug use the following when starting:
@ start
@ layout split
@ layout reg
@
@
@***********************************************************************
@ The = (equal sign) is used in the ARM Assembler to get the address of a
@ label declared in the .data section. This takes the place of the ADR
@ instruction used in the textbook. 
@ ***********************************************************************

.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 

main:

PUSH {LR}

@*******************
welcome:
@*******************
@ Simply prints the welcome message and then the current inventory

   
    LDR r0, =welcomeMessage  @ Puts the message in r0 to be printed
    BL  printf               @ Calls printf on the wrlcome message

    BL print_inventory @ Jumping to a subroutine to print the inventory

    B  select_grade    @ Jumping to the next section, which is getting a grade

@*******************
print_inventory:
@*******************
@ Prints out however much is left in the inventory

    @ Saving the LR so we can return
    PUSH {LR}

    LDR r0, =currentInventoryHeader   @ Loading header to be printed
    BL printf                         @ Printing the header

    @ Printing the amounts 
    LDR r0, =regularThenNumber    @ Loading the outline
    LDR r1, =regularInventory     @ Prepping to print
    LDR r1, [r1]                  @ Dereferencing
    BL printf                     @ Printing 
    
    LDR r0, =midThenNumber        @ Loading the outline
    LDR r1, =midInventory         @ Prepping to print
    LDR r1, [r1]                  @ Dereferencing
    BL printf                     @ Printing 

    LDR r0, =premiumThenNumber    @ Loading the outline
    LDR r1, =premiumInventory     @ Prepping to print
    LDR r1, [r1]                  @ Dereferencing
    BL printf                     @ Printing 

    LDR r0, =dollarAmountByGrade  @ Prepping to print the next header
    BL printf                     @ Printing
    
    @ Printing the dollar amounts
    LDR r0, =regularThenNumberDollar  @ Loading the outline
    LDR r1, =regularSpent             @ Prepping to print
    LDR r1, [r1]                      @ Dereferencing
    BL printf                         @ Printing 
    
    LDR r0, =midThenNumberDollar      @ Loading the outline
    LDR r1, =midSpent                 @ Prepping to print
    LDR r1, [r1]                      @ Dereferencing
    BL printf                         @ Printing 

    LDR r0, =premiumThenNumberDollar  @ Loading the outline
    LDR r1, =premiumSpent             @ Prepping to print
    LDR r1, [r1]                      @ Dereferencing
    BL printf                         @ Printing 

    @ Branching back to where it was called
    POP {PC}




@*******************
select_grade:
@*******************
@ Gets the grade from the user 
@ Uses that grade to jump to a subroutine that updates the specified amount

@ First to check to see if it is done
    
    @ checking regular
    LDR r6, =regularInventory  @ finding the address in memory
    LDR r6, [r6]               @ dereferencing
    CMP r6, #10                @ comparing to 10, if it is negative then we don't have enough
    BPL actually_select_grade  @ if we have enough, then we can continue
    
    @ checking mid-grade
    LDR r6, =midInventory      @ finding the address in memory
    LDR r6, [r6]               @ dereferencing
    CMP r6, #10                @ comparing to 10, if it is negative then we don't have enough
    BPL actually_select_grade  @ if we have enough, then we can continue
    

    @ checking premium
    LDR r6, =premiumInventory  @ finding the address in memory
    LDR r6, [r6]               @ dereferencing
    CMP r6, #10                @ comparing to 10, if it is negative then we don't have enough
    BPL actually_select_grade  @ if we have enough, then we can continue
    
    @ Printing one more time before it exits
    BL  print_inventory  

    @ If we get here, then we are all out
    B  myExit

@ Now to actually let them pick a grade
actually_select_grade:

    LDR r0, =selectGrade    @ Prepping to print the prompt
    BL printf               @ Printing

    @ Getting their character
    BL get_char             @ Getting their input character

    @ Checking to see if their input (in r1) is any of the options:
    @ R, M, P, or I (for inventory)
    CMP   r1, #'R' @ Comparing with R
    BEQ   regular

    CMP   r1, #'M' @ Comparing with M
    BEQ   mid_grade
    
    CMP   r1, #'P' @ Comparing with P
    BEQ   premium
   
    CMP   r1, #'I' @ Comparing with I
    BLEQ  print_inventory

    @ Jumping back up to the top so that when the inventory print returns, it doesn't die
    B select_grade

@*******************
regular:
@*******************
@ Prints that they have selected regular and then asks them for the input.
@ Updates specifically the amount for regular and then returns to main

    LDR r1, =regularStr      @ Saving the string "regular" so that we can use it in any of the prints we want
                             @ both in the regular subroutine and also in the not_enough routine

    @ Checking to see if we have enough regular to give any to them
    LDR  r6, =regularInventory   @ Loading the memory address of the regular inventory
    LDR  r8, [r6]                @ Dereferencing
    CMP  r8, #11                 @ Comparing to 11, if it is negative then we don't have enough
    BMI  not_enough              @ Telling them that there isn't enough

    LDR r0, =youSelected    @ Prepping to print the output format
    BL  printf

get_regular_amount:         @ A place to jump to if we need to request an amount again

    @ Requesting the dollar amount
    BL  get_dollar_amount    

    @ Calculating the amount to dispense
    MOV r1, r5, LSL #2      @ Dispensing 4 tenths of a gallon for each dollar (remember how fast shifts are?)
    
    @ Trying the subtraction
    CMP r8, r1              @ Trying the subtraction (and setting CCR flags)
    
    @ If we don't have enough, we tell them to try again with a lower amount and jump back to regular 
    BPL amount_good_reg     @ Skipping stuff if the amount is good
    LDR r0, =notEnoughLeft  @ Prepping to print
    BL  printf              @ Printing
    B   get_regular_amount  @ Retrying the amount

amount_good_reg:            @ A place to jump to if the amount is okay 
   
    @ If we do have enough, we can go ahead and subtract and store the information in memory
    SUB r8, r8, r1          @ Performing the subtraction
    STR r8, [r6]

    @ Updating the amount spent on regular
    LDR r6, =regularSpent   @ Getting the address of the regular spent variable
    LDR r7, [r6]            @ Getting the actual value of the variable, while also not changing the address in r6
    ADD r7, r7, r5          @ Performing the addition and storing it in r7
    STR r7, [r6]            @ Overwriting the stored information with the updated value


    @ Printing out what they dispensed
    LDR r0, =gallonsDispensed @ Prepping to print
    BL printf                 @ Printing

    @ Going back to the main loop
    B select_grade
    


@*******************
mid_grade:
@*******************
@ Prints that they have selected mid-grade and then asks them for the input.
@ Updates specifically the amount for mid-grade and then returns to main

    LDR r1, =midStr      @ Getting the mid-grade string so that we can use it in any of the prints

    @ Pulling the amount of regular left from memory 
    LDR  r6, =midInventory @ Loading the memory address
    LDR  r8, [r6]          @ Dereferencing
    CMP  r8, #11           @ Comparing to 11, if it is negative then we don't have enough
    BMI  not_enough        @ Telling them that there isn't enough

    LDR r0, =youSelected @ Prepping to print the output format
    BL  printf

get_mid_amount:          @ A place to jump to if we need to request an amount again

    @ Requesting the dollar amount
    BL  get_dollar_amount    

    @ Calculating the amount to dispense
    MOV r2, #3             @ Getting a 3 to use in our multiplication
    MUL r1, r5, r2         @ Dispensing 3 tenths of a gallon for each dollar 
    
    CMP r8, r1             @ Trying the subtraction 
    
    @ If we don't have enough, we tell them to try again with a lower amount and jump back to regular 
    BPL amount_good_mid    @ Skipping stuff if the amount is good
    LDR r0, =notEnoughLeft @ Prepping to print
    BL  printf             @ Printing
    B   get_mid_amount     @ Retrying the amount

amount_good_mid:           @ A place to jump to if the amount is okay 
   
    @ If we do have enough, we can go ahead and store the information in memory
    SUB r8, r8, r1          @ Performing the subtraction
    STR  r8, [r6]

    @ Updating the amount spent on mid-grade
    LDR r6, =midSpent      @ Getting the address of the mid-grade spent variable
    LDR r7, [r6]           @ Getting the actual value of the variable, while also not changing the address in r6
    ADD r7, r7, r5         @ Performing the addition and storing it in r7
    STR r7, [r6]           @ Overwriting the stored information with the updated value


    @ Printing out what they dispensed
    LDR r0, =gallonsDispensed @ Prepping to print
    BL printf                 @ Printing

    @ Going back to the main loop
    B select_grade
    

@*******************
premium:
@*******************
@ Prints that they have selected premium and then asks them for the input.
@ Updates specifically the amount for premium and then returns to main

    LDR r1, =premiumStr      @ Getting the premium string to use in any of the prints

    @ Pulling the amount of premium left from memory
    LDR  r6, =premiumInventory   @ Loading the memory address
    LDR  r8, [r6]                @ Dereferencing
    CMP  r8, #11                 @ Comparing to 11, if it is negative then we don't have enough
    BMI  not_enough              @ Telling them that there isn't enough

    LDR r0, =youSelected     @ Prepping to print the output format
    BL  printf

get_premium_amount:          @ A place to jump to if we need to request an amount again

    @ Requesting the dollar amount
    BL  get_dollar_amount    

    @ Calculating the amount to dispense
    MOV r1, r5, LSL #1      @ Dispensing 2 tenths of a gallon for each dollar (remember how fast shifts are?)
    
    CMP r8, r1              @ Trying the subtraction 
    
    @ If we don't have enough, we tell them to try again with a lower amount and jump back to regular 
    BPL amount_good_prem    @ Skipping stuff if the amount is good
    LDR r0, =notEnoughLeft  @ Prepping to print
    BL  printf              @ Printing
    B   get_premium_amount  @ Retrying the amount

amount_good_prem:           @ A place to jump to if the amount is okay 
   
    @ If we do have enough, we can go ahead and store the information in memory
    SUB r8, r8, r1          @ Performing the subtraction
    STR r8, [r6]

    @ Updating the amount spent on premium
    LDR r6, =premiumSpent   @ Getting the address of the premium spent variable
    LDR r7, [r6]            @ Getting the actual value of the variable, while also not changing the address in r6
    ADD r7, r7, r5          @ Performing the addition and storing it in r7
    STR r7, [r6]            @ Overwriting the stored information with the updated value


    @ Printing out what they dispensed
    LDR r0, =gallonsDispensed @ Prepping to print
    BL printf                 @ Printing

    @ Going back to the main loop
    B select_grade
    
@*******************
not_enough:
@*******************
@ Prints that there is not enough of the selected gas (the address of the name must be in r1)

    LDR r0, =notEnoughMessage @ Prepping to print (the arg is already in r1)
    BL printf                 @ Printing
    B select_grade            @ Back to the main loop

@*******************
get_dollar_amount:
@*******************
@ Requests a dollar amount from the user and puts it in r5

    @ Saving the LR into the stack so that I can jump back to the calling function
    PUSH {LR}           

    LDR r0, =enterMonies  @ Prepping to print the prompt
    BL  printf            @ Printing
    BL  get_int           @ Getting the input

    @ Checking their input to make sure that is between 1 and 50 (inclusive)
    CMP r5, #51   @ Comparing with 51, if it is positive, then it is too high
    BPL too_high
    CMP r5, #1    @ Comparing with 1, if it is negative, then it is too low (does a r5-1, which means that the only invalid numbers would be negative)
    BMI too_low

    POP {PC} @ Returning


@*******************
too_high:
@*******************
@ Prints out that it is too high and gets the dollar amount again

    LDR r0, =tooHighStr  @ Prepping to print
    BL  printf           @ Printing
    POP {LR}             @ Moving the top of the stack to the LR so that it doesn't try to save the LR again
    B   get_dollar_amount

@*******************
too_low:
@*******************
@ Prints out that it is too low and gets the dollar amount again

    LDR r0, =tooLowStr   @ Prepping to print
    BL  printf           @ Printing
    POP {LR}             @ Moving the top of the stack to the LR so that it doesn't try to save the LR again
    B   get_dollar_amount


@*******************
get_char:
@*******************
@ Set up r0 with the address of input pattern.
@ scanf puts the input value at the address stored in r1. We are going
@ to use the address for our declared variable in the data section - intInput. 
@ After the call to scanf the input is at the address pointed to by r1 

   @ Saving the LR on the stack so that we can return
   PUSH {LR}

ask_again_char:               @ A spot to jump back to without messing with the stack for errors

   LDR  r0, =charInputPattern @ Setup to read in one number.
   LDR  r1, =charInput        @ load r1 with the address of where the
                              @ input value will be stored. 
   BL   scanf                 @ scan the keyboard.
   CMP  r0, #READERROR        @ Check for a read error.
   BEQ  readerror_char        @ If there was a read error go handle it. 
   LDR  r1, =charInput        @ Have to reload r1 because it gets wiped out. 
   LDRB r1, [r1]              @ Read the contents of int

   @ Returning
   POP {PC}

@*******************
get_int:
@*******************
@ Gets the input value and stores it in r5
@ Note that it also catches errors and 
@ reruns until we get a good input

   @ Saving the LR on the stack so that we can return
   PUSH {LR}

ask_again_int:              @ A spot to jump back to without messing with the stack for errors

   LDR r0, =numInputPattern @ Setup to read in one number.
   LDR r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   BL  scanf                @ scan the keyboard.
   CMP r0, #READERROR       @ Check for a read error.
   BEQ readerror_int        @ If there was a read error go handle it. 
   LDR r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   LDR r5, [r1]             @ Read the contents of intInput and store in r5

   @ Returning
   POP {PC}


@***********
print_dispensed:
@***********
@ Prints the amount dispensed to the user
@ Expects the amount to be stored in r5

   @ Saving the LR on the stack so that we can return
   PUSH {LR}

   LDR r0, =gallonsDispensed   @ Prepping to print the output format
   MOV r1, r5                  @ Prepping the input to be printed
   BL printf                   @ Actually printing

   @ Returning
   POP {PC}


@***********
readerror_int:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

    @ Saving LR for later
    PUSH {LR}

    LDR  r0, =clearInputPattern
    LDR  r1, =strInputError   @ Put address into r1 for read.
    BL   scanf                @ scan the keyboard.

@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.
@  First, though, we need to ask them to input the number again

    LDR  r0, =badIntInput    @ Prepping to print
    BL   printf              @ Printing

    B ask_again_int  @ Asking for the int again

@***********
readerror_char:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   LDR  r0, =clearInputPattern
   LDR  r1, =strInputError    @ Put address into r1 for read.
   BL   scanf                 @ scan the keyboard.

@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.
@  First, though, we need to ask them to input the char again

   LDR  r0, =badCharInput    @ Prepping to print
   BL   printf               @ Printing

   B ask_again_char   @ Asking for the char agian

@*******************
myExit:
@*******************
@ End of the code. Force the exit and return control to OS

@ Printing out a thank you message
    LDR r0, =byebye @ Prepping to print
    BL  printf       @ printing

@ Return to the OS
POP {PC}

.data

@ Declare the strings and data needed

@ Output for inventory checking

.balign 4
welcomeMessage: .asciz "Welcome to gasoline pump.\n"

.balign 4
regularThenNumber: .asciz "Regular    %d\n"

.balign 4
midThenNumber: .asciz "Mid-Grade  %d\n"

.balign 4
premiumThenNumber: .asciz "Premium    %d\n"

.balign 4
regularThenNumberDollar: .asciz "Regular    $%d\n"

.balign 4
midThenNumberDollar: .asciz "Mid-Grade  $%d\n"

.balign 4
premiumThenNumberDollar: .asciz "Premium    $%d\n\n"

.balign 4
currentInventoryHeader: .asciz "Current inventory of gasoline (in tenths of gallons) is:\n\n"


@ Format for requesting gas 

.balign 4
selectGrade: .asciz "Select Grade of gas to dispense (R, M, or P). You can also type 'I' to display the inventory.\n"

.balign 4
youSelected: .asciz "You selected %s.\n"

@ The variables for how much has been spent and how much is left
.balign 4
regularInventory: .word 500
.balign 4
regularSpent: .word 0
.balign 4
midInventory: .word 500
.balign 4
midSpent: .word 0
.balign 4
premiumInventory: .word 500
.balign 4
premiumSpent: .word 0


# The strings to print for each one 
.balign 4
regularStr: .asciz "regular"
.balign 4
midStr: .asciz "mid-grade"
.balign 4
premiumStr: .asciz "premium"
.balign 4
inventoryStr: .asciz "Inventory"

.balign 4
enterMonies: .asciz "Enter Dollar amount to dispense (At least 1 and no more than 50)\n$"


.balign 4
tooLowStr: .asciz "That input was too low, remember, it must be greater than or equal to 1.\n"

.balign 4
tooHighStr: .asciz "That input was too high, remember, it must be no greater than 50.\n"


.balign 4
notEnoughLeft: .asciz "There is not enough gas left for that much, please try again with a lower value.\n"

.balign 4
dollarAmountByGrade: .asciz "\nDollar amount dispensed by grade:\n\n"

.balign 4
gallonsDispensed: .asciz "%d tenth(s) of gallons have been dispensed.\n"

.balign 4
outOfRangeDollarAmount: .asciz "Your input of $%d is not between 1 and 50.\nAlso keep in mind that it must be an integer.\nPlease try again.\n"

.balign 4
notEnoughGas: .asciz "There was not enough gas to fulful your request.\nPlease enter a new, lower dollar amount.\n$"

.balign 4
badIntInput: .asciz "We were unable to read that input, please try again.\nRemember, it needs to be an integer.\n"

.balign 4
badCharInput: .asciz "We were unable to read that input, please try again.\nRemember, it needs to be a single character.\n"

.balign 4
notEnoughMessage: .asciz "There is not enough %s, unfortunately, as there is less than a gallon left.\nFeel free to use any of the other grades that have more gas.\n"

.balign 4
byebye: .asciz "\nThank you for using this gas pump, but it is out of gas.\nExiting...\n\n"



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
