.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb
.global   quicksort
.global   partition
.global   swap


@ quicksort subroutine
@ Sort an array of words using Hoare's quicksort algorithm
@ https://en.wikipedia.org/wiki/Quicksort 

@ Parameters:
@ R0: Array start address
@ R1: lo index of portion of array to sort
@ R2: hi index of portion of array to sort

@ Return:
@ none


quicksort:
  PUSH    {R5-R8, LR}                     
  @ add any registers R5...R12 that you use

  @ *** PSEUDOCODE ***
  @ if (lo < hi) { // !!! You must use signed comparison (e.g. BGE) here !!!
  @ p = partition(array, lo, hi);
  @ quicksort(array, lo, p - 1);
  @ quicksort(array, p + 1, hi);
  @ }

  @ your implementation goes here

  MOV R5, R0                 
  MOV R6, R1                 
  MOV R7, R2                 
  CMP R1, R2                 
  BGE EndIf

If:
  BL partition                      
  MOV R8, R0                 
  MOV R0, R5                 
  MOV R1, R6                 
  SUB R2, R8, #1             
  BL quicksort
  MOV R0, R5                 
  ADD R1, R8, #1             
  MOV R2, R7                 

EndIf:
  POP     {R5-R8, PC}        

@ partition subroutine
@ Partition an array of words into two parts such that all elements before some
@   element in the array that is chosen as a 'pivot' are less than the pivot
@   and all elements after the pivot are greater than the pivot.
@
@ Based on Lomuto's partition scheme (https://en.wikipedia.org/wiki/Quicksort)
@
@ Parameters:
@   R0: array start address
@   R1: lo index of partition to sort
@   R2: hi index of partition to sort
@
@ Return:
@   R0: pivot - the index of the chosen pivot value

partition:
  PUSH    {R5-R9, LR}        

  @ *** PSEUDOCODE ***
  @ pivot = array[hi];
  @ i = lo;
  @ for (j = lo; j <= hi; j++) {
  @   if (array[j] < pivot) {
  @     swap (array, i, j);
  @     i = i + 1;
  @   }
  @ }
  @ swap(array, i, hi);
  @ return i;
  @
  @ your implementation goes here
  @

  LDR R5, [R0, R2, LSL#2]    
  MOV R6, R1                 
  MOV R7, R1                 
  MOV R9, R2                 

For:
  CMP R7, R9                 
  BGE ForEnd
  LDR R8, [R0, R7, LSL#2]      
  CMP R8, R5              
  BGE Increment              
  MOV R2, R7
  BL swap                  
  ADD R6, R6, #1             

Increment:
  ADD R7, R7, #1                 
  B For

ForEnd:
  BL      swap
  MOV     R0, R6
  POP     {R5-R11, PC}           

@ swap subroutine
@ Swap the elements at two specified indices in an array of words.
@
@ Parameters:
@   R0: array - start address of an array of words
@   R1: a - index of first element to be swapped
@   R2: b - index of second element to be swapped
@
@ Return:
@   none

swap:
  PUSH    {R5-R6, LR}

  @
  @ your implementation goes here
  @

  LDR     R5, [R0, R1, LSL#2]
  LDR     R6, [R0, R2, LSL#2]
  STR     R5, [R0, R2, LSL#2]
  STR     R6, [R0, R1, LSL#2]
  POP     {R5-R6, PC}
.end