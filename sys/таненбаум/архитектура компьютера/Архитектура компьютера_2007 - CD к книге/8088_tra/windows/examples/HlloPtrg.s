! This program prints the string
! "hello world" by scanning every
! byte and stopping with a message
! when either a 0-byte is encountered
! or when the procedure fails.
 
	_EXIT	= 1	!  1
	_WRITE	= 4	!  2
	_STDIN	= 0	!  3
	_STDOUT	= 1	!  4
	_STDERR	= 2	!  5
	_PRINTF = 127	!  6
	SUCCESS	= 1	!  7
.SECT .TEXT		!  8
start:			!  9
	MOV  AX,SUCCESS	! 10
	MOV	DI,hw	! 11
	PUSH	AX	! 12
	PUSH	hw	! 13
	PUSH	_STDOUT	! 14
	PUSH	_WRITE	! 15
	MOV	BP,SP	! 16
1:	MOV    4(BP),DI	! 17
	SCASB		! 18
	JE	2f	! 19
	SYS		! 20
	SUB  AX,SUCCESS	! 21
	JNE	1f	! 22
	JMP	1b	! 23
1:	SUB	SP,8	! 24
	NEG	AX	! 25
	PUSH	AX	! 26
	PUSH	we	! 27
	JMP	3f	! 28
2:	PUSH	AX	! 29
	PUSH	sr	! 30
3:	PUSH _PRINTF	! 31
	SYS		! 32
	ADD	SP,4	! 33
	PUSH	_EXIT	! 34
	SYS		! 35
.SECT .DATA		! 36
we:			! 37
.ASCIZ	"write error\\n"! 38
sr:			! 39
.ASCIZ "string ready\\n"! 40
hw:			! 41
.ASCIZ	"Hello World\\n"! 42
de:	.BYTE	0	! 43

.SECT .BSS
