  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   fp_exp
  .global   fp_frac
  .global   fp_enc



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
  PUSH    {LR, R2}                      @ add any registers R4...R12 that you use
  MOV R0, R0, LSL 1                     @ shifting bit to left to 1
  MOV R0, R0, LSR 24                    @ shifting bit to right to 24

  MOV R2, #127                          @ putting 127 to get calculate the correct bit
  SUB R0, R0, R2                        @ subtrating R2 from R0 to get the exponent
  @
  @ your implementation goes here
  @

  POP   {R2,PC}                      @ add any registers R4...R12 that you use



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