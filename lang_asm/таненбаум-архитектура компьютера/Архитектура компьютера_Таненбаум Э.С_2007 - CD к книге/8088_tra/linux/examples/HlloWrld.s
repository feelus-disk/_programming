! Simple "hello world" program
! See section 9.8.1.

	_EXIT	= 1		!  1
	_WRITE	= 4		!  2
	_STDOUT	= 1		!  3
.SECT .TEXT			!  4
start:				!  5
	MOV	CX,de-hw	!  6
	PUSH	CX		!  7
	PUSH	hw		!  8
	PUSH	_STDOUT		!  9
	PUSH	_WRITE		! 10
	SYS			! 11
	ADD	SP,8		! 12
	SUB	CX,AX		! 13
	PUSH	CX		! 14
	PUSH	_EXIT		! 15
	SYS			! 16
.SECT .DATA			! 17
hw:				! 18
.ASCII	"Hello World\n"		! 19
de:	.BYTE	0		! 20
.SECT .BSS
