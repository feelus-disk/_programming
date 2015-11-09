! This program prints the string 
! "Hello World" on a one byte basis
! using a loop and a base pointer address.

	_EXIT	= 1		!  1
	_WRITE	= 4		!  2
	_STDOUT	= 1		!  3
	SUCCESS	= 1		!  4
.SECT .TEXT			!  5
start:				!  6
	MOV	CX,de-hw	!  7
	PUSH	CX		!  8
	PUSH	1		!  9
	PUSH	hw		! 10
	MOV	BP,SP		! 11
	PUSH	_STDOUT		! 12
	PUSH	_WRITE		! 13
1:	SYS			! 14
	SUB	AX,SUCCESS	! 15
	JNE	1f		! 16
	INC	(BP)		! 17
	LOOP	1b		! 18
1:	SUB	SP,8		! 19
	PUSH	AX		! 20
	PUSH	_EXIT		! 21
	SYS			! 22
.SECT .DATA			! 23
hw:				! 24
.ASCII	"Hello World\\n"	! 25
de:	.BYTE	0		! 26
.SECT .BSS
