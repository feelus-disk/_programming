! This program is meant to print a line in reverse order.
! It is one of the string manipulation routines discussed
! in section 9.8.5.

#include "../syscalnr.h"		!  1
start:	MOV   DI,str			!  2
	PUSH  AX			!  3
	MOV   BP,SP			!  4
	PUSH  _PUTCHAR			!  5
	MOVB  AL,'\n'			!  6
	MOV   CX,-1			!  7
	REPNZ SCASB			!  8
	NEG   CX			!  9
	STD				! 10
	DEC   CX			! 11
	SUB   DI,2			! 12
	MOV   SI,DI			! 13
1:	LODSB				! 14
	MOV   (BP),AX			! 15
	SYS				! 16
	LOOP  1b			! 17
	MOVB  (BP),'\n'			! 18
	SYS				! 19
	PUSH 0				! 20
	PUSH _EXIT			! 21
	SYS				! 22
.SECT .DATA				! 23
xyz: .ASCIZ "This one is wrong\n"
str: .ASCIZ "reverse\n"			! 24
