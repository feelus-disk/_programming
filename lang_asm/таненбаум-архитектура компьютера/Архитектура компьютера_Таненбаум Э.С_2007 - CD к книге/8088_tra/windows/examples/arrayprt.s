! This program is supposed to print a
! vector, but it contains errors, which
! must be corrected first.
! See text section 9.8.4.

#include "..\\syscalnr.h"	 !  1

.SECT .TEXT			 !  2
vecpstrt:			 !  3
	MOV  BP,SP		 !  4
	PUSH vec1		 !  5
	MOV  CX,frmatstr-vec1	 !  6
	SHR  CX			 !  7
	PUSH CX			 !  8
	CALL vecprint		 !  9
	MOV  SP,BP		 ! 10
	PUSH 0			 ! 11
	PUSH _EXIT		 ! 12
	SYS			 ! 13

.SECT .DATA			 ! 14
vec1:   .WORD 3,4,7,11,3	 ! 15
frmatstr: .ASCIZ "%s"		 ! 16

frmatkop:			 ! 17
.ASCIZ "The array contains "	 ! 18
frmatint: .ASCIZ " %d"		 ! 19
.SECT .TEXT			 ! 20
vecprint:			 ! 21
	PUSH BP			 ! 22
	MOV  BP,SP		 ! 23
	MOV  CX,4(BP)		 ! 24
	MOV  BX,6(BP)		 ! 25
	MOV  SI,0		 ! 26
	PUSH frmatkop		 ! 27
	PUSH frmatstr		 ! 28
	PUSH _PRINTF		 ! 29
	SYS			 ! 30
	MOV  -4(BP),frmatint	 ! 31
1:	MOV  DI,(BX)(SI)	 ! 32
	MOV  -2(BP),DI		 ! 33
	SYS			 ! 34
	INC  SI			 ! 35
	LOOP 1b			 ! 36
	PUSH '\n'		 ! 37
	PUSH _PUTCHAR		 ! 38
	SYS			 ! 39
	MOV  SP,BP		 ! 40
	RET			 ! 41
.SECT .BSS
