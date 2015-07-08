#include	"../syscalnr.h"
.SECT .TEXT
linnumst:
	PUSH _GETCHAR
	MOV  DX,0
	MOV  CX,DX
	MOV  BX,DX
	MOV  DI,linnumbf
1:	SYS
	CMP  AX,0
	JLE  9f
	CMPB AL,'\n'
	JE   8f
	CMPB AL,'\t'
	JE   7f
	CMPB AL,' '
	JL   1b
	CMPB AL,0177
	JG   1b
	STOSB
	INC  DX
	INC  CX
	JMP  1b
7:	STOSB
	INC  CX
	ADD  DX,8
	AND  DX,0XFFF8
	JMP  1b
8:	CMP  CX,0
	JE   8f
	PUSH CX
	PUSH linnumbf
	PUSH _STDOUT
	PUSH _WRITE
	SYS
	AND  DX,0XFFF8
	push 9
	push _PUTCHAR
3:	SYS
	ADD  DX,8
	CMP  DX,40
	JL   3b
	ADD  SP,12
	INC  BX
	PUSH BX
	PUSH linnumfm
	PUSH _PRINTF
	SYS
	MOV  DI,linnumbf
	ADD  sp,6
	MOV  CX,0
	MOV  DX,CX
	JMP 1b
8:	PUSH AX
	PUSH _PUTCHAR
	SYS
	ADD  SP,4
	JMP 1b
9:	PUSH 0
	PUSH _EXIT
	SYS
.SECT .DATA
linnumfm: .ASCIZ "!%3d\n"
.SECT .BSS
linnumbf: .SPACE 80
