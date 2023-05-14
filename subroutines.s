  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global  get9x9
  .global  set9x9
  .global  average9x9
  .global  blur9x9


@ get9x9 subroutine
@ Retrieve the element at row r, column c of a 9x9 2D array
@   of word-size values stored using row-major ordering.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@
@ Return:
@   R0: element at row r, column c
get9x9:
  PUSH    {R4-R5, LR}               @ add any registers R4...R12 that you use
  @
  @ your implementation goes here
  @
  MOV     R5, #9                    @ rowSize = 9
  MUL     R4, R1, R5                @ index = r * rowSize
  ADD     R4, R4, R2                @ index = index + c
  LDR     R0, [R0, R4, LSL#2]       @ element = word[address + index * 4]
  POP     {R4-R5, PC}               @ add any registers R4...R12 that you use



@ set9x9 subroutine
@ Set the value of the element at row r, column c of a 9x9
@   2D array of word-size values stored using row-major
@   ordering.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@   R3: value - new word-size value for array[r][c]
@
@ Return:
@   none
set9x9:
  PUSH    {R4-R5, LR}               @ add any registers R4...R12 that you use

  @
  @ your implementation goes here
  @
  MOV     R5, #9                    @ rowSize = 9
  MUL     R4, R1, R5                @ index = r * rowSize
  ADD     R4, R4, R2                @ index = index + c
  STR     R3, [R0, R4, LSL#2]       @ array[r][c] = value
  POP     {R4-R5, PC}               @ add any registers R4...R12 that you use



@ average9x9 subroutine
@ Calculate the average value of the elements up to a distance of
@   n rows and n columns from the element at row r, column c in
@   a 9x9 2D array of word-size values. The average should include
@   the element at row r, column c.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@   R3: n - element radius
@ 
@ Return:
@   R0: average value of elements
@ Local variables:
@   R4: count
@   R5: temp
@   R6: total
@   R7: tempR
@   R8: tempC
@   R9: temp2
@   R10: total elements
average9x9:
  PUSH    {R4-R10, LR}               @ add any registers R4...R12 that you use

  @
  @ your implementation goes here
  @
  MOV R10, #0
  MOV R7, R1                        @ tempR = r
  MOV R8, R2                        @ tempC = c
  MOV R9, #0
  MOV R5, #2                        @ R5 = 2
  MUL R4, R3, R5                    @ R4 = n*2
  ADD R9, R9, R4                    @ R9 = R4
  ADD R4, R4, #1                    @ R4 += 1
  ADD R8, R8, R4                    @ R8 += R4
  MUL R4, R4, R4                    @ R4 *= R4
  ADD R10, R10, R4                  @ R10 += R4 
  MOV R5, R0                        @ R5 = address
  MOV R6, #0                        @ total = 0

Wh:
  CMP R4, #0                        @ while(count!=0){
  BEQ EndWh   

  SUB R1, R1, R3                    @ r -= n
  SUB R2, R2, R3                    @ c -= n
  BL get9x9                         @ subArray[r][c] = element
  ADD R6, R6, R0                    @ total = total + element
  MOV R0, R5                        @ R0 = temp
  SUB R4, R4, #1                    @ count -= 1
  CMP R2, R8                        @ if(c<tempC){
  BHS IfGreater                     @ c += 1
  ADD R2, R2, #1                    @ }
  B Wh
IfGreater:                          @ else{
  SUB R2, R2, R9                    @ c -= temp2
  ADD R1, R1, #1                    @ r += 1  
  B Wh                              @}

EndWh:
  UDIV R0, R6, R10                  @ average = total / total number of elements
  POP     {R4-R10, PC}              @ add any registers R4...R12 that you use



@ blur9x9 subroutine
@ Create a new 9x9 2D array in memory where each element of the new
@ array is the average value the elements, up to a distance of n
@ rows and n columns, surrounding the corresponding element in an
@ original array, also stored in memory.
@
@ Parameters:
@   R0: addressA - start address of original array
@   R1: addressB - start address of new array
@   R2: n - radius
@
@ Return:
@   none
blur9x9:
  PUSH    {LR}                      @ add any registers R4...R12 that you use

  @
  @ your implementation goes here
  @

  POP     {PC}                      @ add any registers R4...R12 that you use

.end