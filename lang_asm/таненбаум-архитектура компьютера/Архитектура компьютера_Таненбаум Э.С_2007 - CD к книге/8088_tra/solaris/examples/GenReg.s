
	_EXIT	= 1		!  1
.SECT .TEXT			!  2
start:				!  3
	MOV	AX,258		!  4
	ADDB	AH,AL		!  5
	MOV	CX,(times)	!  6
	MOV	BX,muldat	!  7
	MOV	AX,(BX)		!  8
1:	MUL	2(BX)		!  9
	LOOP	1b		! 10
.SECT .DATA			! 11
times:	.WORD	10		! 12
muldat:	.WORD	625,2		! 13
.SECT .TEXT			! 14
	PUSH	0		! 15
	PUSH	_EXIT		! 16
	SYS			! 17
.SECT .BSS
