! This program shows a "dispatch table"
! which can be used when the program has
! to choose from many altenatives like in
! the "switch" statement of the C language.
! See text section 9.8.6.

#include "../syscalnr.h" !  1
.SECT .TEXT		 !  2
jumpstrt:		 !  3
	PUSH strt	 !  4
	MOV  BP,SP	 !  5
	PUSH _PRINTF	 !  6
	SYS		 !  7
	PUSH _GETCHAR	 !  8
1:	SYS		 !  9
	CMP  AX,5	 ! 10
	JL   8f		 ! 11
	CMPB AL,'0'	 ! 12
	JL   1b		 ! 13
	CMPB AL,'9'	 ! 14
	JLE  2f		 ! 15
	MOVB AL,'9'+1	 ! 16
2:	MOV  BX,AX	 ! 17
	AND  BX,0Xf	 ! 18
	SAL  BX,1	 ! 19
	JMP  tbl(BX)	 ! 20
!	CALL tbl(BX)	 ! 20
!	JMP  1b		 ! 21
8:	PUSH 0		 ! 22
	PUSH _EXIT	 ! 23
	SYS		 ! 24

rout0:  MOV  AX,mes0	 ! 25
	JMP  9f		 ! 26
rout1:  MOV  AX,mes1	 ! 27
	JMP  9f		 ! 28
rout2:  MOV  AX,mes2	 ! 29
	JMP  9f		 ! 30
rout3:  MOV  AX,mes3	 ! 31
	JMP  9f		 ! 32
rout4:  MOV  AX,mes4	 ! 33
	JMP  9f		 ! 34
rout5:  MOV  AX,mes5	 ! 35
	JMP  9f		 ! 36
rout6:  MOV  AX,mes6	 ! 37
	JMP  9f		 ! 38
rout7:  MOV  AX,mes7	 ! 39
	JMP  9f		 ! 40
rout8:  MOV  AX,mes8	 ! 41
	JMP  9f		 ! 42
erout:  MOV  AX,emes	 ! 43
9:	PUSH  AX	 ! 44
	PUSH  _PRINTF	 ! 45
	SYS  		 ! 46
	ADD  SP,4	 ! 47
	JMP 1b		 ! 48
!	RET		 ! 48

.SECT .DATA		 ! 49
tbl: .WORD rout0,rout1,rout2,rout3,rout4,rout5,rout6,rout7,rout8,rout8,erout ! 50
mes0: .ASCIZ "This is a zero.\n"				 ! 51
mes1: .ASCIZ "How about a one.\n"				 ! 52
mes2: .ASCIZ "You asked for a two.\n"				 ! 53
mes3: .ASCIZ "The digit was a three.\n"				 ! 54
mes4: .ASCIZ "You typed a four.\n"				 ! 55
mes5: .ASCIZ "You preferred a five.\n"				 ! 56
mes6: .ASCIZ "A six was encountered.\n"				 ! 57
mes7: .ASCIZ "This is number seven.\n"				 ! 58
mes8: .ASCIZ "This digit is not accepted as an octal.\n"	 ! 59
emes: .ASCIZ "This is not a digit. Try again.\n"		 ! 60
strt: .ASCIZ "Type an octal digit with a return. Stop on end of file.\n" !61
