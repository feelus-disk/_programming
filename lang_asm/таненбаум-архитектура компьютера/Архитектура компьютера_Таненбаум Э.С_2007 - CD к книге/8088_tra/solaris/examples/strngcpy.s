
.SECT .TEXT
stcstart:			!  1
	PUSH mesg1		!  2
	PUSH mesg2		!  3
	CALL strngcpy		!  4
	ADD  SP,4		!  5
	PUSH 0			!  6
	PUSH 1			!  7
	SYS			!  8
strngcpy:			!  9
	PUSH CX			! 10
	PUSH SI			! 11
	PUSH DI			! 12
	PUSH BP			! 13
	MOV  BP,SP		! 14
	MOV  AX,0		! 15
	MOV  DI,10(BP)		! 16
	MOV  CX,-1		! 17
	REPNZ SCASB		! 18
	NEG  CX			! 19
	DEC CX			! 20
	MOV  SI,10(BP)		! 21
	MOV  DI,12(BP)		! 22
	PUSH DI			! 23
	REP  MOVSB		! 24
	CALL stringpr		! 25
	MOV  SP,BP		! 26
	POP  BP			! 27
	POP  DI			! 28
	POP  SI			! 29
	POP  CX			! 30
	RET			! 31
.SECT .DATA			! 32
mesg1: .ASCIZ "Have a look\n"	! 33
mesg2: .ASCIZ "qrst\n"		! 34
.SECT .BSS
