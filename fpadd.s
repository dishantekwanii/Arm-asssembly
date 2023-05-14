  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   fp_add

@ fp_add subroutine
@ Add two IEEE-754 floating point numbers
@
@ Paramaters:
@   R0: a - first number
@   R1: b - second number
@
@ Return:
@   R0: result - a+b
@
fp_add:
  PUSH    {R4, R5, R6, R7, R8, R9, R10, R11, LR} @ add any registers R4...R12 that you use
  MOV R4, R0                                 @ Copies the numbers in R0 and R1 into R4 and R5
  MOV R5, R1             
  CMP R0,R1

  BL fp_exp                                  @ Calls fp_exp and stores the value of the exponent into R0
  MOV R6, R0                                 @ R6 now has the exponent of first number

  MOV R0, R5                                 @ R0 now has the second number in it 
  BL fp_exp                                 @ Calls fp_exp for the second number and stores the value of sexond number's exp in R0
  MOV R7, R0                                 @ R7 now has the exponent of second number in it

  MOV R0, R4                                 @ R0 now has the first number in it
  BL fp_frac                                 @ Calls fp_frac and stores the fraction value into its R0
  MOV R8, R0                                 @ R8 Now has the fraction of the first number

  MOV R0, R5                                 @ moves R5 to R0
  BL fp_frac                                 @ Calculates the fraction of second number and stores it in R0
  MOV R9, R0                                 @ Stores the fraction of second number into R9

  CMP R6, R7                                 @ if R6<R7
  BGE FUCK_YOU    @ Branch to EXP_GE
  LOOP:                                      @ and then branches to EQUAL_EXPONENTS
  ADD R6, R6, #1
  MOV R8, R8, LSR#1
  CMP R6, R7                                 @ Loops unti R6 and R7 are equal
  BEQ EQUAL_EXPONENTS                        @ Moves the decimal point towards left and adds 1 to the exponent
  B LOOP
  
  
  
  FUCK_YOU:

  CMP R6, R7                                 @ if R6>R7
  BEQ EQUAL_EXPONENTS                        @ Branch to IFGREATERTHAN
  LOOP1:
  ADD R7, R7, #1                             @ Adds one to the 
  MOV R9, R9, LSR#1
  CMP R6, R7
  BEQ EQUAL_EXPONENTS                        @ Moves the decimal point towards left
  B LOOP1

  EQUAL_EXPONENTS:                           @ if equal
  ADD R0, R8, R9    
  MOV R1, R6                       
  BL fp_enc                                             
  IFEQUAL:


  POP     {R4, R5, R6, R7, R8, R9, R10, R11, PC}  @ add any registers R4...R12 that you use


@ fp_exp subroutine
@ Obtain the exponent of an IEEE-754 (single precision) number as a signed
@   integer (2's complement)
@
@ Parameters:
@   R0: IEEE-754 number
@
@ Return:
@   R0: exponent (signed integer using 2's complement)
fp_exp:
  PUSH    {LR, R2}                         @ add any registers R4...R12 that you use
  MOV R0, R0, LSL 1                        @ shifting bit to left to 1
  MOV R0, R0, LSR 24                       @ shifting bit to right to 24

  MOV R2, #127                             @ putting 127 to get calculate the correct bit
  SUB R0, R0, R2                           @ subtrating R2 from R0 to get the exponent
  @
  @ your implementation goes here
  @

  POP   {R2,PC}                            @ add any registers R4...R12 that you use



@ fp_frac subroutine
@ Obtain the fraction of an IEEE-754 (single precision) number.
@
@ The returned fraction will include the 'hidden' bit to the left
@   of the radix point (at bit 23). The radix point should be considered to be
@   between bits 22 and 23.
@
@ The returned fraction will be in 2's complement form, reflecting the sign
@   (sign bit) of the original IEEE-754 number.
@
@ Parameters:
@   R0: IEEE-754 number
@
@ Return:
@   R0: fraction (signed fraction, including the 'hidden' bit, in 2's
@         complement form)
fp_frac:
  PUSH    {LR, R1,R2}                      @ add any registers R4...R12 that you use
  MOV R1, R0, LSR 31                       @ shifting bit to right to 31
  MOV R0, R0, LSL 9                        @ shifting bit to left to 9

  MOV R0, R0, LSR 9                        @ shifting bit to left to 9 again to get the correct bit element
  MOV R2, #8388608                         @ interchanging the position to 8388608 to get the correct result
  ADD R0, R0, R2                           @ adding R2 to R0 to get the fraction
  CMP R1, #1                               @ comapring if R1 is positive
  BNE Skip                                 @ if it is positive then skip
  NEG R0, R0                               @ if negative then making it negative
Skip:
  
  @
  @ your implementation goes here
  @

  POP     {R2, R1, PC}                      @ add any registers R4...R12 that you use



@ fp_enc subroutine
@ Encode an IEEE-754 (single precision) floating point number given the
@   fraction (in 2's complement form) and the exponent (also in 2's
@   complement form).
@
@ Fractions that are not normalised will be normalised by the subroutine,
@   with a corresponding adjustment made to the exponent.
@
@ Parameters:
@   R0: fraction (in 2's complement form)
@   R1: exponent (in 2's complement form)
@
@ Return:
@   R0: IEEE-754 single precision floating point number
fp_enc:
  PUSH    {LR, R4, R5, R1, R6}                      @ add any registers R4...R12 that you use
  MOV R4, R0, LSR 24                                @ Shifting bit to right to 24
  MOV R0, R0, LSL 9                                 @ shifting bit to left to 9
  MOV R5, R0, LSR 9                                 @ shifting bit to left again to get the correct bit element

  CMP R4, #1                                        @ running a loop to compare if it is positive
  BNE Skip2                                         @ if positive, it skips
  NEG R5, R5                                        @ if not positive then making it negative
Skip2:

  

  ADD R1, R1, #127                                  @ adding the 127 to calculate the bit position
  MOV R0, R4, LSL 31                                @ shifting bit to left to 31
  MOV R1, R1, LSL 23                                @ shifting bit to left again to get the correct bit element
  ADD R0, R0, R1                                    @ adding R1 TO R0 to get fraction

  ADD R0, R0, R5                                    @ adding R5 TO R0 to get exponent
  @
  @ your implementation goes here
  @

  POP     {R6, R1, R5, R4, PC}                      @ add any registers R4...R12 that you use



.end