!	EIGHT BYTE INTEGER POCKET CALCULATOR IN REVERSE POLISH

! This program emulates a stack oriented integer machine in polish notation.
! The central data structure consists of eight byte signed long ints, which
! are pushed onto and popped from a stack which is called "nstack".
! The size of this stack is 1024 of those longs. Moreover the emulated
! machine has a memory containing 26 of those eight byte variables,
! which are indicated by the variable names "A" through "Z".
! The machine is supposed to read commands and integers from standard input.
! The operators all pop their arguments from the stack and push the result.
! The admitted binary operators are: addition, indicated by a "+" character;
! subtraction, "-"; multiplication, "*"; integer division discarding
! the remainder, indicated by a ":" character; and the remainder operation
! indicated by "%". 
! There is a unary minus operator "~"; a pop from stack operator "p";
! duplicate top of stack "d"; and exchange the two integers on the top of
! the stack "x". The operator "^" prints the entire stack, and if an end of
! line is encountered the top element of the stack is printed if available.
! If the input is numerical, the indicated number is pushed onto the stack.
! The command "sA" is a store operation, which pops the top of stack and stores
! it into the variable "A"; retrieval is done with the "r" command, so "rZ"
! gets the value of variable "Z" and pushes it onto the stack.
! The command "q" terminates the program.
! As an example program we could try
! 35 18-d*dsA\n  which pushes first 35, then 18, computes the difference,(17)
! duplicates and multiplies it (289) duplicate and stores it in "A".
! The end of line prints the top of stack, so the result is 289.

! The aim of this exercise is: First to understand the calculation
! Secondly to program an extra feature in such a way that the calculator
! accepts lines in infix notation. In this infix notation the operators are
! put between the numbers, and the order of evaluation can be influenced by
! means of parentheses. Those infix notation lines will be recognised
! by an equal sign "=" at the end of a line. If such a line is encountered,
! then it must be converted into reversed polish notation. After the converted
! line is processed the result is on top of the stack, and this value is printed
! because of the end of line which is encountered after the "=" sign.
! In the section "Stack addressing" this conversion process is discussed.
! Note that in infix notation the operators "x" "p" "d" "q" and "s" cannot
! be used. Provisions should be made that recalled variable can be used in
! stead of numbers, so "rA+rB=\n" is admitted and must give the expected answer.

! Central in the program is the integer stack "nstack" which consists
! of 1024 8-byte integers. The stack is used from high to low addresses
! and register BX is used to indicate the top of stack.
! After a line is read from standard input into the buffer "inputb" it is
! scanned one character at the time. Two integer buffers "curbuf" and "nxtbuf"
! are used to keep the bytes which are to be processed. A copy of "curbuf"
! is kept in DX, and "nxtbuf" is used to have a read ahead of one byte.
! The routine "getcbuf" copies the "nxtbuf" into DX and "curbuf" and moves
! another byte into "nxtbuf". The input line in "inputb" is scanned by means
! of a pointer variable "pinbuf".

.SECT .TEXT
	TEN = 0xa		! Use this constant for decimal printouts

start:
	MOV 	BX,stkend	! Puts the register BX at the end of the nstack
	CLD
0:	CALL	rdline		! Read an input line into the inputb
	CALL    central		! Execute the commands in the inputb
	CALL    snlcr		! Output top of stack
	JMP     0b		! Start again by the read line

central:			! The central interpretation loop
1:	CALL getcbuf
	MOV  AX,DX		! Copy input character into AX
	CMP  AX,0		! Zero means end of buffer, finish central.
	JLE  3f
	SHL  AX,1		! Double the value of the input byte to
	MOV  DI,AX		! use it in the dispatch table DTABLE
	CALL DTABLE(DI)		! The register DI is used to govern the call.
	JMP  1b
3:	RET

squit:	PUSH	(null)		! Exit system call routine.
	PUSH	(_exit)
	SYS

rdline:	MOV  DI,inputb		! Use DI register to store characters in inputb
	XOR  CX,CX		! Cleanup CX, which counts the number of bytes
	PUSH (_getchar)		! Prepare for the read byte from standard in
1:	SYS			! get next byte
	CMP  AX,0
	JL   9f			! finish on AX<0, i.e. end of file.
	CMPB AL,'\b'
	JE   8f			! move one character back on a backspace
	STOSB			! store character in inputb, auto increment DI
	INC  CX			! One more character read
	CMP  AX,'\n'
	JNE  1b			! If not end of line, get next byte
	MOVB (DI),'\0'		! Close input string with a zero byte
	MOV  (pinbuf),inputb	! put input pointer at the start of the line
	CALL getcbuf		! Fill the next character buffer
	ADD  SP,2		! Stack cleanup
	RET

8:	CMP  CX,0 		! Correct current line with backspaces.
	JE   1b			! No correction at the start of the line
	DEC  CX			! Decrement byte count
	DEC  DI			! Decrement buffer pointer
	JMP  1b

9:	PUSH eofmes		! Close process on end of input
	PUSH (_printf)
	SYS			! Print exit message
	ADD  SP,4
	CALL squit		! and terminate program

getcbuf: PUSH AX		! Save AX
	XOR  DX,DX		! Cleanup DX
	MOVB DL,(nxtbuf)	! Get DL from nxtbuf
	MOV  (curbuf),DX	! Fill curbuf
	XCHG SI,(pinbuf)	! get pointer from pinbuf
	LODSB			! Get next character from inputb; increment SI
	MOVB (nxtbuf),AL	! Fill nxtbuf with new character
	XCHG (pinbuf),SI	! Restore SI and pot neww value in pinbuf
 	POP AX			! Restore AX
 	RET			! Back

! The three registers BX, SI and DI which can be used to point in the data
! segment are used to boint to the bottom address of the 8-byte integers which
! are used as the basic data units in this exercise. The BX register governs
! the nstack, and the DI and SI point to the destination and the source for
! the integers used in the computation. So the basic computations used those
! registers in every computation, and we need routines to clean the integer
! variables indicated, to copy and exchange them, for addition, subtraction,
! multiplication, division, and the determination of remainders. Because these
! last three computations involve complicated loops in their routines there
! are five scratch variables oper1 through oper5, which are used for this 
! purpose.

clrd:	PUSH DX			! Put 8-byte value 0 in the variable under DI
	XOR  DX,DX		! Cleanup DX
	MOV  (DI),DX		! and enter this value 0 into four consecutive
	MOV  2(DI),DX		! memory words indicated by DI
	MOV  4(DI),DX
	MOV  6(DI),DX
	POP  DX
	RET

clrs:	XCHG SI,DI		! Put 8-byte value 0 in the variable under SI
	CALL clrd		! by exchangeing the pointers twice and clrd
	XCHG DI,SI
	RET

pushd:  SUB  BX,2		! Push 8-byte integer under DI onto nstack
	MOV  AX,6(DI)		! using the register BX as its stackpointer 
	MOV  (BX),AX
	SUB  BX,2
	MOV  AX,4(DI)
	MOV  (BX),AX
	SUB  BX,2
	MOV  AX,2(DI)
	MOV  (BX),AX
	SUB  BX,2
	MOV  AX,(DI)
	MOV  (BX),AX
	RET

srshift: SHR 6(SI),1		! Right shift 8-byte integer under SI
	RCR 4(SI),1
	RCR 2(SI),1
	RCR (SI),1
	RET

slshift:SHL  (SI),1		! Left shift 8-byte integer under SI
	RCL  2(SI),1
	RCL  4(SI),1
	RCL  6(SI),1
	JC   9f			! Jump on carry set	(Unsigned overflow)
	JO   9f			! Jump on overflow	(Signed overflow)
	CMP  6(SI),0
	JL   9f			! Jump on negative	(Signed overflow)
	RET
9:	PUSH shfterr
	PUSH (_printf)
	SYS
	ADD  SP,4
	RET

dlshift:XCHG SI,DI		! Left shift 8-byte integer under DI
	CALL slshift		! by exchanging the registers SI and DI
	XCHG DI,SI
	RET

cpsd:	MOV  AX,(SI)		! Copy variable under SI to variable under DI
	MOV  (DI),AX
	MOV  AX,2(SI)
	MOV  2(DI),AX
	MOV  AX,4(SI)
	MOV  4(DI),AX
	MOV  AX,6(SI)
	MOV  6(DI),AX
	RET

cpds:	MOV  AX,(DI)		! Copy variable under DI to variable under SI
	MOV  (SI),AX
	MOV  AX,2(DI)
	MOV  2(SI),AX
	MOV  AX,4(DI)
	MOV  4(SI),AX
	MOV  AX,6(DI)
	MOV  6(SI),AX
	RET

subsd:	MOV  AX,(SI)		! Subtract source (SI) from destination (DI)
	SUB  (DI),AX
	MOV  AX,2(SI)
	SBB  2(DI),AX
	MOV  AX,4(SI)
	SBB  4(DI),AX
	MOV  AX,6(SI)
	SBB  6(DI),AX
	RET

addsd:	MOV  AX,(SI)		! Add source (SI) to destination (DI)
	ADD  (DI),AX
	MOV  AX,2(SI)
	ADC  2(DI),AX
	MOV  AX,4(SI)
	ADC  4(DI),AX
	MOV  AX,6(SI)
	ADC  6(DI),AX
	RET

mulsd:	PUSH CX			! Multiply source (SI) to destination (DI)
	PUSH BX
	MOV  BX,oper2		! Use oper2 as a 16 byte shift register.
	MOV  (BX),0
	MOV  2(BX),0
	MOV  4(BX),0
	MOV  6(BX),0
	MOV  CX,64
1:	SHL  (BX),1	! Multiplication is shift followed by add in case of a 1
	RCL  2(BX),1
	RCL  4(BX),1
	RCL  6(BX),1
	RCL  8(BX),1
	RCL  10(BX),1
	RCL  12(BX),1
	RCL  14(BX),1
	SHL  (SI),1	! Shift the source
	RCL  2(SI),1
	RCL  4(SI),1
	RCL  6(SI),1
	JNC  2f		! and look if a carry is shifted out. This would be a 1
	INC  (SI)	! in that case this inc makes a rotate for the source
	MOV  AX,(DI)	! and the add of the multiplyer is done here
	ADD  (BX),AX
	MOV  AX,2(DI)
	ADC  2(BX),AX
	MOV  AX,4(DI)
	ADC  4(BX),AX
	MOV  AX,6(DI)
	ADC  6(BX),AX
	ADC  8(DI),0	! multiplyers are just 8 byte, so only adc from here
	ADC  10(DI),0
	ADC  12(DI),0
	ADC  14(DI),0
2:	LOOP 1b
	MOV  AX,(BX)
	MOV  (DI),AX
	MOV  AX,2(BX)
	MOV  2(DI),AX
	MOV  AX,4(BX)
	MOV  4(DI),AX
	MOV  AX,6(BX)
	MOV  6(DI),AX
	POP  BX
	POP  CX
	RET

divsd:	! Divides the positive number addressed by DI by the number in (SI).
	! Keeps the sources unchanged, but copies them into
	! oper1, oper2 en oper3
	! stores remainder in oper1, divisor in oper2 en quotient in oper3.
	PUSH CX
	PUSH BX
	MOV  BX,oper3
	XCHG BX,DI
	CALL clrd	! Get an 8-byte 0 value
	CALL cmpds	! Compare with divisor under SI
	CMP  AX,0
	JE   9f		! And jump to error is divisor is zero
	XCHG DI,BX
	PUSH DI
	PUSH SI
	PUSH DI
	MOV  DI,oper2	! Scratch variable oper2 in DI
	CALL cpsd	! Copy source value i.e the divisor to oper2
	MOV  DI,oper1
	POP  SI 	! Old DI is extracted as SI as source for the divident
	CALL cpsd	! and the divident is copied to oper1
	MOV  SI,oper2
	XOR  CX,CX
0:	CALL cmpds	! Next compare divident and divisor
	CMP  AX,0
	JL   2f
	JE   3f
	ADD  CX,1
	CALL slshift	! Shift left divisor left until its larger than divident
	JMP  0b		! Determines ho often subtraction should be attempted.
2:	CMP   CX,0
	JE    8f	! Never shifted, then divident is rest
	DEC  CX
	CALL srshift
3:	ADD  (BX),1	! Increment quotient
	ADC  2(BX),0
	ADC  4(BX),0
	ADC  6(BX),0
	CALL subsd	! Subtract shifted divisor from divident
4:	CMP  CX,0
	JE   8f		! Nothing to shift, then ready
	DEC  CX
	CALL srshift	! right shift divisor (i.e. backwards)
	XCHG DI,BX
	CALL dlshift	! left shift quotient
	XCHG BX,DI
	CALL cmpds	! Compare again if subtraction is necessary
	CMP  AX,0
	JGE  3b		! Yes: Increment quotient again and subtract (Label 3)
	JMP  4b		! No: Shifts only (Label 4)
8:	POP  SI		! Divisor back at original value in oper2
	POP  DI		! oper3 contains quotient.
	JMP 6f		! oper1 contains remainder
9:	XCHG DI,BX
	PUSH nulmes	! Print message division by 0 refused
	PUSH (_printf)
	SYS
	ADD  SP,4
6:	POP  BX
	POP  CX
	RET

! From here we get the routines which push and pop variables on the stack
! The input commands calls those routines from the dispatch table.
! The first routine supplies the address of a variable from its name in DX

getvar:  CALL getcbuf		! Read variable name (between A and Z)
	MOV  AX,DX
	CMP  AX,90
	JG   9f
	SUB  AX,65
	JL   9f
	SHL  AX,1
	SHL  AX,1
	SHL  AX,1
	ADD  AX,varbuf
	MOV  DI,AX
	RET
9:	MOV  DI,8*26
	PUSH varmes
	PUSH (_printf)
	SYS
	ADD  SP,4
	RET

store:  CALL getvar	! Store top of nstack in indicated variable
	MOV  SI,BX
	CALL cpsd
	ADD  BX,8
	RET

recall:	CALL getvar	! Load top of nstack from indicated variable
	SUB  BX,8
	MOV  SI,BX
	CALL cpds
	RET

sxchg:  MOV  DI,oper1		! Exchange top two values of nstack 
	MOV  SI,BX
	CALL cpsd
	MOV  DI,BX
	ADD  DI,8
	CALL cpds
	MOV  SI,oper1
	CALL cpsd
	RET

spop:	CMP  BX,stkend	! Pop top of nstack and discard the value
	JGE  topstck
	ADD BX,8
	RET

topstck: PUSH stlg	! Print end of nstack message
	PUSH (_printf)
	SYS
	ADD  SP,4
	RET

sneg:	NOT  6(BX)	! negate value at top of nstack
	NOT  4(BX)
	NOT  2(BX)
	NOT  (BX)
	ADD  (BX),1
	ADC  2(BX),0
	ADC  4(BX),0
	ADC  6(BX),0
	RET

smin:   CALL sneg	! Subtraction is negation followed by addition
	CALL splus
	RET

splus:  MOV  SI,BX	! Add top two members on the nstack
	ADD  BX,8
	MOV  DI,BX
	CALL addsd
	RET

smul:	XOR  DX,DX	! Multiply top two members of the nstack
	MOV  SI,BX
	CMP  6(BX),0
	JGE  1f
	NOT  DX		! Multiplication is done on positive values, sign is
	CALL sneg	! saved and used later. So if negative negate.
1:	ADD  BX,8
	MOV  DI,BX
	CMP  6(BX),0
	JGE  1f
	NOT  DX		! Here we process the sign of the other operand
	CALL sneg
1:	CALL mulsd
	CMP  DX,0
	JE   1f
	CALL sneg
1:	RET

sdivi:	XOR  DX,DX	! Divide the second value of the nstack by the top
	MOV  SI,BX
	CMP  6(BX),0
	JGE  1f
	CALL sneg	! Again save the sign and process positive integers
	NOT  DX
1:	CALL dup
	ADD  BX,16
	MOV  DI,BX
	CMP  6(BX),0
	JGE  1f
	CALL sneg
	NOT  DX
1:	CALL divsd	! Call of the division operation.
	MOV  SI,oper1
	SUB  DI,8
	CALL cpsd
	MOV  SI,oper3
	MOV  DI,BX
	CALL cpsd
	CMP  DX,0
	JE   1f
	ADD  (DI),1
	ADC  2(DI),0
	ADC  4(DI),0
	ADC  6(DI),0
	CALL sneg
	SUB  BX,8
	CALL sneg
	SUB  BX,8
	CALL splus
	ADD  BX,8
1:	RET

srest:  CALL sdivi	! Determine the remainder by division.
	SUB  BX,8
	CALL sxchg
	ADD  BX,8
	RET

sprint: PUSH BX		! Prints all values on the nstack on a single line.
	MOVB (nlcr),' '
1:	CMP  BX,stkend
	JGE  1f
	CALL snlcr
	ADD  BX,8
	JMP  1b
1:	MOVB (nlcr),'\n'
	PUSH stckm
	PUSH (_printf)
	SYS
	ADD  SP,4
	POP BX
	RET

separ:  snop: RET	! no op at white space

snlcr:	PUSH DX		! Print top of nstack
	MOV  DI,oper4
	MOV  SI,BX
	CALL cpsd
	MOV  SI,oper5
	CALL clrs
	MOV  (SI),TEN
	XOR  DX,DX
	CMP  6(BX),0
	JGE  1f
	NOT  DX
	XCHG BX,DI
	CALL sneg
	XCHG DI,BX
1:	PUSH BX
	MOV  BX,wrtln+510
	MOV  AX,(nlcr)
	MOV  (BX),AX
2:	CALL divsd		! Divide number by ten convert the remainder	
	MOV  SI,oper1
	DEC  BX
	MOVB AL,(SI)
	ADDB AL,'0'		! to an ascii symbol and put it in a buffer
	MOVB (BX),AL
	MOV  SI,oper3
	CALL cpsd
	MOV  SI,oper5
	CMP  6(DI),0
	JNE  2b
	CMP  4(DI),0
	JNE  2b
	CMP  2(DI),0
	JNE  2b
	CMP  (DI),0
	JNE  2b
	CMP  DX,0
	JE   1f
	DEC  BX
	MOVB (BX),'-'
1:	PUSH BX			! Print the buffer
	PUSH (_printf)
	SYS
	ADD  SP,4
	POP  BX
	POP  DX
	RET

dup:	MOV  SI,BX	! Duplicate top of nstack
	SUB  BX,8
	MOV  DI,BX
	CALL cpsd
	RET


cmpds:	! Compares 8-byte integers in (SI) and (DI). Result is 1 if (DI)>(SI);
	! 0 if (DI)=(SI); and  -1 if (SI)>(DI); return value is put in AX.
	PUSH CX
	MOV  AX,6(SI)
	MOV  CX,6(DI)
	CMP  CX,AX
	JL   6f
        JG   7f
	MOV  AX,4(SI)
	CMP  4(DI),AX
	JB   6f
        JA   7f
	MOV  AX,2(SI)
	CMP  2(DI),AX
	JB   6f
        JA   7f
	MOV  AX,(SI)
	CMP  (DI),AX
	JB   6f
        JA   7f
	MOV  AX,0
	POP CX
	RET
6:	MOV  AX,-1
	POP CX
	RET
7:	MOV  AX,1
	POP CX
	RET

snum:	MOV  SI,oper2		! Digit encountered in input. Assemble entire
	MOV  DI,oper1		! integer from the input buffer and push it
	CALL clrd		! onto the nstack
	AND  DX,15
	MOV  (DI),DX
1:	CMP  (nxtbuf),48
	JL   8f
	CMP  (nxtbuf),57
	JG   8f
	CALL cpds
	CALL dlshift
	CALL dlshift
	CALL addsd
	CALL dlshift
	CALL clrs
	CALL getcbuf
	AND  DX,15
	MOV  (SI),DX
	CALL addsd
	JMP  1b
8:	CALL pushd
	RET

.SECT .DATA
null:		.WORD	0
_getchar:	.WORD	117
_printf:	.WORD	127
_putchar:	.WORD	122
one: _exit:	.WORD	1
_open:		.WORD	5
_read:		.WORD	3
_eof:		.WORD	0Xffff
curbuf:	.WORD  0	! Current value of input buffer as word variable
nxtbuf:	.WORD  0	! Next value of input buffer as word variable
pinbuf:	.WORD  0	! Next position in input buffer to be put in nxtbuf

! Next we get the 128 byte dispatch table which is used to jump to the
! indicated routines on a byte from the input buffer.

DTABLE:	.WORD	squit,	snop,	snop,	snop,	squit,	snop,	snop,	snop
	!	cntrl-0 cntrl-A cntrl-B cntrl-C cntrl-D cntrl-E cntrl-F bell
	.WORD	snop,	separ,	separ,	separ,	separ,	separ,	snop,	snop
	!	back	hortab	newline	vertab	newpag	carret	shout	shin
	.WORD	snop,	snop,	snop,	snop,	snop,	snop,	snop,	snop
	.WORD	snop,	snop,	snop,	snop,	snop,	snop,	snop,	snop
	.WORD	separ,	snop,	snop,	snop,	snop,	srest,	snop,	snop
	!	space	!	"	#	$	%	&	'
	.WORD	snop,	snop,	smul,	splus,	snop,	smin,	snop,	snop
	!	(	)	*	+	,	-	.	/
	.WORD	snum,	snum,	snum,	snum,	snum,	snum,	snum,	snum
	!	0	1	2	3	4	5	6	7
	.WORD	snum,	snum,	sdivi,	snop,	snop,	snop,	snop,	snop
	!	8	9	:	;	<	=	>	?
	.WORD	snop,	snop,	snop,	snop,	snop,	snop,	snop,	snop
	!	@	A	B	C	D	E	F	G
	.WORD	snop,	snop,	snop,	snop,	snop,	snop,	snop,	snop
	!	H	I	J	K	L	M	N	O
	.WORD	snop,	snop,	snop,	snop,	snop,	snop,	snop,	snop
	!	P	Q	R	S	T	U	V	W
	.WORD	snop,	snop,	snop,	snop,	snop,	snop,	sprint,	snop
	!	X	Y	Z	[	\	]	^	-
	.WORD	snop,	snop,	snop,	snop,	dup,	snop,	snop,	snop
	!	`	a	b	c	d	e	f	G
	.WORD	snop,	snop,	snop,	snop,	snop,	snop,	snop,	snop
	!	h	i	j	k	l	m	n	O
	.WORD	spop,	squit,	recall,	store,	snop,	snop,	snop,	snop
	!	p	q	r	s	t	u	v	W
	.WORD	sxchg,	snop,	snop,	snop,	snop,	snop,	sneg,	snop
	!	x	y	z	{	|	}	~	delete

nlcr:	 .ASCIZ "\n"
shfterr: .ASCIZ "Overflow in shift. Number loaded is too large.\n"
eofmes:	 .ASCIZ "Getchar reads end of file.\n"
symerro: .ASCIZ "Error encountered in input line.\n"
varmes:	 .ASCIZ "Variable not defined.\n"
nulmes:	 .ASCIZ "Division by zero is refused.\n"
stckm:	 .ASCIZ "Stack\n"
stlg:	 .ASCIZ "Stack underflow encountered.\n"

.SECT .BSS
nstack:	.SPACE 8192		! This is the main 8-byte integer stack
stkend: wrtln: .SPACE 512	! End of nstack, and start of write buffer
oper1:	.SPACE 8		! Five scratch variables for multiplication
oper2:	.SPACE 16		! and division 
oper3:	.SPACE 8
oper4:	.SPACE 8
oper5:	.SPACE 8
varbuf: .SPACE 216		! Space reserved for variables A-Z
inputb: .SPACE 512		! The main input buffer
