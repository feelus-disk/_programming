#include	"../syscalnr.h"
.SECT .TEXT
stpstart:			!  1
	PUSH msg1		!  2
	CALL stringpr		!  3
	PUSH msg2		!  4
	CALL stringpr		!  5
	ADD  SP,4		!  6
	PUSH 0			!  7
	PUSH 1			!  8
	SYS			!  9
stringpr:			! 10
	PUSH CX			! 11
	PUSH SI			! 12
	PUSH DI			! 13
	PUSH BP			! 14
	MOV  BP,SP		! 15
	MOV  AX,0		! 16
	MOV  DI,10(BP)		! 17
	MOV  SI,DI		! 18
	MOV  CX,-1		! 19
	REPNZ SCASB		! 20
	NOT  CX			! 21
	DEC  CX			! 22
	MOV  DI,strpribf	! 23
	PUSH CX			! 24
	PUSH DI			! 25
	PUSH STDOUT		! 26
	PUSH _WRITE		! 27
	REP  MOVSB		! 28
	STOSB			! 29
	SYS			! 30
	MOV  SP,BP		! 31
	POP  BP			! 32
	POP  DI			! 33
	POP  SI			! 34
	POP  CX			! 35
	RET			! 36
.SECT .DATA			! 37
.SECT .BSS			! 38
strpribf:			! 39
	.SPACE 88		! 40
.SECT .DATA			! 41
msg1: .ASCII "Look here msg1\n"	! 42
msg2: .ASCIZ "And msg\0762\n"	! 43
