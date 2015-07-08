! A simple program to read from standard input.

	_PRINTF = 127	!  1
	_GETCHAR = 117	!  2
	_EXIT = 1	!  3
	asciinl = 10	!  4
	EOF = -1	!  5
.SECT .TEXT		!  6
start:			!  7
	MOV DI,STR	!  8
	PUSH _GETCHAR	!  9
1:	SYS		! 10
	CMP  AX,EOF	! 11
	JE   9f		! 12
	STOSB		! 13
	CMPB AL,asciinl	! 14
	JNE  1b		! 15
	MOVB (DI),0	! 16
	PUSH STR	! 17
	PUSH _PRINTF	! 18
	SYS		! 19
	ADD SP,4	! 20
	MOV DI,STR	! 21
	JMP 1b		! 22
9:	PUSH 0		! 23
	PUSH _EXIT	! 24
	SYS		! 25
.SECT .DATA		! 26
.SECT .BSS		! 27
STR:	.SPACE 80	! 28
