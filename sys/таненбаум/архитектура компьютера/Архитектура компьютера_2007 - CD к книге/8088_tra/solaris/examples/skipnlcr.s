#include "../syscalnr.h"
ARGSIZ = 128
argstart:
	MOV  BP,SP
	CMP  (BP),2
	JNE  9f
	POP  (argc)
	CALL getargs
	PUSH 1
	PUSH buf
again:	PUSH (infildes)
	PUSH _READ
	SYS
	CMP  AX,1
	JL   8f
	ADD  SP,4
	CMPB (buf),'\015'
	JE   7f
bufput:	PUSH (outfldes)
	PUSH _WRITE
	SYS
	CMP  AX,1
	JL   3f
	ADD  SP,4
	JMP  again
9:	PUSH noargs
errprt:	PUSH _PRINTF
	SYS
8:	PUSH 0
	PUSH _EXIT
	SYS
	
7:	PUSH 1
	PUSH xbuf
	PUSH (infildes)
	PUSH _READ
	SYS
	CMP  AX,1
	JGE  1f
	ADD  SP,8
	JMP  bufput
1:	CMPB (xbuf),'\012'
	JNE  5f
	ADD  SP,4
	PUSH (outfldes)
	PUSH _WRITE
	SYS
	CMP  AX,1
	JL   3f
	ADD  SP,8
	JMP  again
5:	ADD  SP,8
	PUSH (outfldes)
	PUSH _WRITE
	SYS
	CMP  AX,1
	JL   3f
	PUSH 1
	PUSH xbuf
	PUSH (outfldes)
	PUSH _WRITE
	SYS
	ADD  SP,12
	JMP  again
3:	PUSH wrerr
	JMP  errprt

getargs:
	MOV  SI,2
	MOV  BX,argv1
	MOV  CX,(argc)
1:	MOV  AX,(BP)(SI)
	PUSH BP
	MOV  BP,AX
	ADD  SI,2
	MOV  DI,0
2:	MOVB AL,(BP)(DI)
	MOVB (BX)(DI),AL
	INC  DI
	CMPB AL,0
	JNE  2b
	ADD  BX,ARGSIZ
	POP  BP
	LOOP 1b
	PUSH 0
	PUSH argv1
	PUSH _OPEN
	SYS
	CMP  AX,0
	JL   9f
	MOV  (infildes),AX
	PUSH 0644
	PUSH argv2
	PUSH _CREAT
	SYS
	CMP  AX,0
	JL   8f
	MOV  (outfldes),AX
	ADD  SP,12
	RET

8:	ADD  SP,2
	PUSH crerr
	JMP  errprt
9:	ADD  SP,2
	PUSH operr
	JMP  errprt
	
.SECT .DATA
noargs:	.ASCIZ "Program skipnlcr expects two file arguments\n"
wrerr:	.ASCIZ "Program skipnlcr encoutered a write error\n"
crerr:	.ASCIZ "Program skipnlcr cannot creat file %s\n"
operr:	.ASCIZ "Program skipnlcr cannot open file %s\n"
.ALIGN 2
.SECT .BSS
infildes: .SPACE 2
outfldes: .SPACE 2
argc:	.SPACE 2
argv1:	.SPACE 128
argv2:	.SPACE 128
buf:	.SPACE 20
xbuf:	.SPACE 20
