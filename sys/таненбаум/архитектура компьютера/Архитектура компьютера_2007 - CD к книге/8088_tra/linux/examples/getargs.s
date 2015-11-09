! This file shows how arguments on the command line can be
! used inside a program.
! Arguments are expected after the interpreter and the assembled program
! So the line "t88 getargs first second third fourth"
! will open the tracer and when the program is run those arguments
! are loaded in the BSS part of the DATA segment and then printed.
!
! The arguments are available in the stack segment and pointers to them are
! pushed onto the stack at the start of the program, similar to the usual
! calling conventions for arguments in a stack oriented loading sequence.
!
! max 7 arguments


.SECT .TEXT		 !  1
ARGSIZ	= 32		 !  2
argstart:		 !  3
	MOV  BP,SP	 !  4
	AND  (BP),0xf	 !  5
	POP  (argc)	 !  6
	CALL getargs	 !  7
	MOV  CX,(argc)	 !  8
	PUSH argv1	 !  9
	PUSH format	 ! 10
	PUSH 127	 ! 11
1:	SYS		 ! 12
	ADD  (BP),ARGSIZ ! 13
	LOOP 1b		 ! 14
	ADD  SP,6	 ! 15
	PUSH 0		 ! 16
	PUSH 1		 ! 17
	SYS		 ! 18

getargs:		 ! 19
	MOV  SI,2	 ! 20
	MOV  BX,argv1	 ! 21
	MOV  CX,(argc)	 ! 22
1:	MOV  AX,(BP)(SI) ! 23
	PUSH BP		 ! 24
	MOV  BP,AX	 ! 25
	ADD  SI,2	 ! 36
	MOV  DI,0	 ! 37
2:	MOVB AL,(BP)(DI) ! 38
	MOVB (BX)(DI),AL ! 39
	INC  DI		 ! 30
	CMPB AL,0	 ! 31
	JNE  2b		 ! 32
	ADD  BX,ARGSIZ	 ! 33
	POP  BP		 ! 34
	LOOP 1b		 ! 35
	RET		 ! 36

.SECT .DATA		 ! 37
argc: .WORD 0		 ! 38
.SECT .BSS		 ! 39
argv1: .SPACE ARGSIZ	 ! 40
argv2: .SPACE ARGSIZ	 ! 41
argv3: .SPACE ARGSIZ	 ! 42
argv4: .SPACE ARGSIZ	 ! 43
argv5: .SPACE ARGSIZ	 ! 44
argv6: .SPACE ARGSIZ	 ! 45
argv7: .SPACE ARGSIZ	 ! 46
format:
.ASCIZ "argument: %s\n"	 ! 47
