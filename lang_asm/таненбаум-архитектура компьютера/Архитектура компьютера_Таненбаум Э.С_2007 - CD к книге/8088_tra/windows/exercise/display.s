!			A TERMINAL EMULATOR
!
!
! The aim of this exercise is to program an emulator for a small display.
! Such a display constists of a set of pixels which are arranged in a 
! rectangular grid. Depending on the purpose of the display a pixel can
! correspond to a bit, a byte, or a set of three or four bytes. Simple black and
! white displays use one bit, color displays often use one byte for the three
! primary colors, and an extra byte for other types of attributes.
! In our exercise we emulate a black and white display in which every pixel
! corresponds to a single bit in a rectangular bitmap.
! Such a display is organised as an array of horizontal
! lines, in which every horizontal line itself is an array of bits.
! At the lowest possible level the bits of all horizontal lines are put
! consecutively in in on large linear array of bits. 
! In the simplest case which is covered by this exercise, every line of the
! display, and hence of the bitmap consists of 288 bits, and the display 
! has 224 scan lines, and so the size of the bit map is 288*224=64512.
! Since eight bits fit in one byte, the entire bitmap consists of 8064 bytes.
! The specifications of the display can be read from the file "sys\term.cf".
! By loading a different configuration file "sys\term?.cf" a different bitmap
! is defined. The contents of the terminal configuration file will be loaded
! in the record variable "tm_hd", and the description of this record can be
! found below.
!
! The aim is to display characters which are typed onto the standard input
! in the display. The exercise asks to put the character maps in the bitmap.
! In the simplest case each printable character is represented by a bitmap
! of 8 bits horizontal and 14 bits vertical. These bitmaps for the characters
! are stored in font files. In the exercise there are four different fonts files
! "sys\n" for the normal font, "sys\r" for reversed video, "sys\u" for
! underscored characters, and "sys\b" for bold face characters.
! Each of those font files consists of a header of 16 bytes and then a set
! of 128 characters, each consisting of 14 * 8 bits, i.e. 14 bytes.
! The preprogrammed subroutine "ft_ld" loads a font file into memory,
! the header goes into the record variable "ft_hd" and the bitmaps for each
! of the 128 characters go into the font table "ft_ch". The file loaded is
! indicated in the font variable "fontl".
! The bitmap for character with ascii number "x" can be fount in the bytes
! 14*x-14*x+13. If one of the other terminal configurations is loaded, then the
! font variable "fontl" should be changed appropriately.

! In order to write the display bitmap in a window there are three different
! pre programmed output methods, which are called from the subroutine
! "tm_wr". If you happen to have the packet "TCL-TK" on yous system, then
! use the subroutine "tclout" and you can put the comment sysmbol "!" in
! front of the other two calls. Otherwise, the "posout" routine writes 
! a postscript image of the bitmap, and the "pbmout" a portable bit map
! image at every call of "tm_wr".  These routines can produce up to 26
! images at conscutive calls of "tm_wr". 

! The aim of the exercise is that in a central loop characters should be read
! from standard input, and for printable charaters the bitmap of that character
! in the current font should be loaded into the terminal bitmap which resides
! in the array variable "tm_ch". In the simplest version the terminal can
! display 16 lines of text, each with a maximum of 36 characters per line.
!
! 1 If the input byte is an end of line then the next printable character should
!   go to the start of the next line in the display. Note that a text line
!   consists of 14 scan lines in the bitmap.
! 2 If a tab symbol CNTRL-i is read, the the next printable character should be
!   displayed at the next tab stop, at line positions 4,8,12,16,20,24,28,32
!   or at the start of the next line.
! 3 Characters between space (32) and tilde (126) should be displayed in the 
!   bitmap
! 4 The characters CNTRL-u CNTRL-r CNTRL-b and CNTRL-n should ask for a font
!   change. The subroutine "ft_ld" can be used after the variable "fontl" is
!   set to the new file name
! 5 All other characters should be ignored.
! 6 If a character does not fit in the line, then it should be displayed at the
!   head of the next line.
! 7 If the number of lines exeeds the maximum, or if an End of File is
!   encountered then the "tm_wr" routine should be executed, and the program
!   should stop.

! CONSTANTS

! sizes of records and caches

	FT_HD_SZ	= 16	! Size of the font table header
	TM_HD_SZ	= 80	! Size of the terminal description header
	FT_CH_SZ	= 4096	! Maximal size of the font table
	TM_CH_SZ	= 8192	! Maximal size of the terminal bitmap in bytes

! layout of terminal record. The constants are the offsets from the head of the
! record "tm_hd".

	TM_SIZE		= 0	! size of this record
	TM_NUMCOL	= 2	! number of character columns on screen
	TM_NUMROW	= 4	! number of character rows on screen
	TM_CHARWID	= 6	! wid of character in bits
	TM_CHARHT	= 8	! height of character in bits
	TM_WID		= 10	! wid of screen in bits
	TM_HT		= 12	! height of screen in bits
	TM_MEMUSE	= 14	! memory size needed for cache
	TM_FONTPATH	= 16	! directory containing font files

! layout of font file header record. The constants are the offsets from the
! head of the record "ft_hd".
	FT_ID		= 0	! magic number
	FT_DUMMY	= 2	! dummy to pad struct
	FT_SIZE		= 4	! size of font data
	FT_CHARS	= 6	! number of character bitmaps
	FT_WID		= 8	! wid of character in bits
	FT_HT		= 10	! height of character in bits
	FT_PADWID	= 12	! wid of character in memory in bits
	FT_PADHT	= 14	! height of character in memory in bits

!
! some other constants
! 
	ROMAN		= 0x6E	! Ascii letter n (normal)
	BOLD		= 0x62	! Ascii letter b (bold)
	REVVID		= 0x72	! Ascii letter r (reverse video)
	UNDERSC		= 0x75	! Ascii letter u (underscores)

	NEWLINE		= 0x0A
	ROMAN_ON	= 0x0E	! Ascii letter cntrl-n (normal)
	BOLD_ON		= 0x02	! Ascii letter cntrl-b (bold)
	REV_ON		= 0x12	! Ascii letter cntrl-r (reverse video)
	OND_ON		= 0x0F	! Ascii letter cntrl-o (underscores)
	UND_ON		= 0x15	! Ascii letter cntrl-u (underscores)

!
! system calls and library routines
!
	_EXIT		= 1			! call number stop program
	_READ		= 3			! file read call
	_WRITE		= 4			! call number write file
			STDIN	= 0		! defined file descriptor input
			STDOUT	= 1		! defined file descriptor output
			STDERR	= 2		! file descriptor error output

	_OPEN		= 5			! call number open file
		O_RDONLY	= 0
		O_WRONLY	= 1
		O_RDWR		= 2

	_CLOSE		= 6
	_CREAT		= 8
	_GETCHAR	= 117
	_SPRINTF	= 121			! print formatted into string
	_SSCANF		= 125			! scan formatted from string
	_PRINTF		= 127			! print formatted onto output
 
! YOU CAN PUT YOUR CONSTANTS HERE

!
! main subroutine
!

.SECT	.TEXT					! program code segment

main:
	CALL	tm_in			! initialise terminal bitmap and headers
	CALL	tm_rd			! main character reading LOOP
	CALL	tm_wr			! write terminal bitmap to output
	CALL	ex_ok			! exit program at success
	RET

!
! initialize terminal
!

tm_in:
	PUSH	AX			! save registers on stack
	PUSH	BX
	PUSH	BP
	MOV	BP, SP

	PUSH	O_RDONLY		! open terminal config file
	PUSH	tm_cf
	PUSH	_OPEN
	SYS
	ADD	SP, 6

	MOV	(fd), AX		! check for open error
	CMP	(fd), 0
	JGE	0f

	PUSH	tm_cf
	CALL	op_err
	ADD	SP, 2

0:					! read terminal config file
	PUSH	TM_HD_SZ		! header size in call
	PUSH	tm_hd			! pointer to filename in call
	PUSH	(fd)			! file descriptor
	PUSH	_READ			! sys routine number in call
	SYS				! the system call itself
	ADD	SP, 8			! cleanup stack

	CMP	AX, TM_HD_SZ		! check for read error terminal config
	JE	1f			! Did we read exactly the header size?

	PUSH	err2			! print error message 2 on failure
	PUSH	_PRINTF
	SYS
	ADD	SP, 4
	CALL	ex_err			! terminate process on error

1:					! check size of screen cache
	MOV	BX, tm_hd		! put bottom of terminal record in BX.
	CMP	TM_MEMUSE(BX), TM_CH_SZ	! check whether bitmap fits in memory
	JLE	2f

	PUSH	err3			! print message 3 on insufficient space
	PUSH	_PRINTF
	SYS
	ADD	SP, 4
	CALL	ex_err			! terminate process on error

2:
	PUSH	(fd)			! close terminal config file
	PUSH	_CLOSE
	SYS
	ADD	SP, 4			! cleanup stack

	CALL	ft_ld			! this routine loads a font table
	MOV	SP, BP
	POP	BP			! restore registers
	POP	BX
	POP	AX
	RET

!
! read input and put their bitmaps at the right place     DO THIS PART YOURSELF
!
.SECT	.DATA				! assemble from here in the data segment

.ALIGN 2				! start the sequel on an even address

! HERE WE CAN PUT OUR INITIALISED VARIABELS

.ALIGN 2

.SECT	.BSS				! assemble from here in the bss segment

.ALIGN 2

! HERE WE CAN PUT OUR UNINITIALISED VARIABELS

.ALIGN 2

.SECT	.TEXT				! assemble in the program code segment


! HERE WE CAN PUT OUR SUBROUTINES

tm_rd:

	RET
!
! write bitmap to stdout
!

tm_wr:					! This routine writes a terminal bitmap
					! of the pbm-format on standard out

	PUSH	AX			! save registers
	PUSH	BX
	PUSH	CX
	PUSH	SI
	PUSH	DI
	PUSH	BP
	MOV	BP, SP
	MOV	BX, tm_hd		! BX indicates start of terminal record

	CALL	posout
	CALL	pbmout
	CALL	tclout

	MOV	SP, BP
	POP	BP			! restore registers
	POP	DI
	POP	SI
	POP	CX
	POP	BX
	POP	AX
	RET

.SECT	.DATA
_bhf:	.ASCIZ	"P4\n%0d %0d\n"		! portable bitmap initialisation header
.SECT	.TEXT

pbmout:
	INCB 	(pstringi+7)
	PUSH	TM_HT(BX)		! Stack height of bitmap in bits
	PUSH	TM_WID(BX)		! Stack width of bitmap in bits
	PUSH	_bhf			! Initialisation header as format
	PUSH	buf
	PUSH	_SPRINTF		! Print header to standard out
	SYS
	ADD	SP, 10			! Cleanup stack
	PUSH 0644
	PUSH pstringi
	PUSH _CREAT
	SYS
	ADD  SP,6
	CMP  AX,0
	JL   crerror
	MOV  (fd),AX
	PUSH buf
	PUSH AX
	CALL stringpr
	ADD  SP,4

	PUSH	TM_MEMUSE(BX)		! Stack size op bitmap
	PUSH	tm_ch			! Start adress of bitmap
	PUSH	(fd)			! File descriptor number on stack
	PUSH	_WRITE			! System call number
	SYS				! Write total bitmap on standard out
	ADD	SP, 2
	PUSH	_CLOSE
	SYS
	ADD	SP,8
	RET

!
! load font data
!

.SECT .DATA
_ffn: .ASCIZ	"%s\\%s"
.SECT	.TEXT

! The following routine loads a font table if the variable fontl contains
! the name of a valid font file. 
! To enter a CNTR-o or a CNTR-r from a terminal can cause problems. In that
! case we enter the CNTRL-v CNTRL-o resp. CNTRL-v CNTRL-r, since the
! CNTRL-v is an terminal escape character for some control characters.

ft_ld:

	PUSH	AX			! save registers
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	PUSH	BP
	MOV	BP, SP

	PUSH	fontl			! Push font file name
	MOV	BX, tm_hd
	LEA	AX, TM_FONTPATH(BX)	! Push font directory
	PUSH	AX
	PUSH	_ffn			! Set the string buffer
	PUSH	buf
	PUSH	_SPRINTF		! format string system call
	SYS				! buf contains pathname of file
	ADD	SP, 10

	PUSH	O_RDONLY		! open font file
	PUSH	buf			! PUSH path name pointer
	PUSH	_OPEN
	SYS
	ADD	SP, 6

	MOV	(fd), AX		! check for open error
	CMP	(fd), 0
	JGE	0f

	PUSH	buf
	CALL	op_err
	ADD	SP, 2

0:
	PUSH	FT_HD_SZ		! read font header
	PUSH	ft_hd
	PUSH	(fd)
	PUSH	_READ
	SYS
	ADD	SP, 8

	CMP	AX, FT_HD_SZ		! check for read error
	JE	1f

	PUSH	err4
	PUSH	_PRINTF
	SYS
	ADD	SP, 4
	CALL	ex_err

1:
	MOV	BX, ft_hd		! check size of font cache
	CMP	FT_SIZE(BX), FT_CH_SZ
	JLE	2f

	PUSH	err5
	PUSH	_PRINTF
	SYS
	ADD	SP, 4
	CALL	ex_err

2:
	PUSH	FT_SIZE(BX)		! read font data
	PUSH	ft_ch
	PUSH	(fd)
	PUSH	_READ
	SYS
	ADD	SP, 8

	CMP	AX, FT_SIZE(BX)		! check for read error
	JE	3f

	PUSH	err6
	PUSH	_PRINTF
	SYS
	ADD	SP, 4
	CALL	ex_err

3:
	PUSH	(fd)			! close font file
	PUSH	_CLOSE
	SYS
	ADD	SP, 6
	MOV	SP, BP
	POP	BP
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET

!
! some small functions
!

op_err:					! Open error routine
	PUSH	BP
	MOV	BP, SP
	PUSH	4(BP)
	PUSH	err1
	PUSH	_PRINTF
	SYS
	ADD	SP, 6
	CALL	ex_err
	MOV	SP, BP
	POP	BP
	RET

ex_err:				! exit in case of an error
	PUSH	1
	PUSH	_EXIT
	SYS

ex_ok:				! exit in case of success
	PUSH	0
	PUSH	_EXIT
	SYS

! global initialized data

.SECT	.DATA

fontl:	.ASCIZ	"n"		! font name normal font (times roman)
tm_cf:	.ASCIZ	"sys\\term.cf"	      ! pathname terminal header
	! for terminal with characters fonts up to 8x14 bits. The window size is
	! 36x16 characters.
	! alternative term9.cf : 9x16 bits, 32x14 characters
	! alternative term7.cf : 7x13 bits, 40x17 characters

err1:	.ASCIZ	"Cannot open %s\n"
err2:	.ASCIZ	"Error reading terminal configuration data\n"
err3:	.ASCIZ	"Screen cache not big enough\n"
err4:	.ASCIZ	"Error reading font header\n"
err5:	.ASCIZ	"Font cache not big enough\n"
err6:	.ASCIZ	"Error reading font data\n"
err7:	.ASCIZ	"Error reading standard input\n"

! some global and often used local variables

.SECT	.BSS
.ALIGN	2
fd:	.SPACE	2			! file descriptor variable
tmbytw:	.SPACE	2			! width of terminal in bytes
buf:	.SPACE	128			! general purpose string buffer
tm_ch:	.SPACE	TM_CH_SZ		! reserve space for termina bitmap
tm_hd:	.SPACE	TM_HD_SZ		! reserve space for terminal record
ft_hd:	.SPACE	FT_HD_SZ		! reserve space for font table header
ft_ch:	.SPACE	FT_CH_SZ		! reserve space for font table
_eod:	.SPACE	2			! dummy variable end of data

.SECT .DATA
pstringa: .ASCII "%!PS-Adobe-2.0 EPSF-2.0\n%%Title: exercise.ps\n"
.ASCII "%%Creator: XV Version 3.10a  Rev: 12/29/94  -  by John Bradley\n"
.ASCII "%%BoundingBox: 32 182 581 611\n%%Pages: 1\n%%EndComments\n"
.ASCII "%%EndProlog\n%%Page: 1 1\n/origstate save def\n20 dict begin\n"
.ASCII "/grays 288 string def \n/npixls 0 def\n"
.ASCIZ "/rgbindx 0 def\n37 187 translate\n538.56000 418.89600 scale\n"
pstringb: .ASCII "\n\n\nshowpage\n% stop using temporary dictionary\nend\n\n"
.ASCIZ "% restore original state\norigstate restore\n\n%%Trailer\n"
pstringc: .ASCII "/pix %d string def\n%d %d 1\n[%d 0 0 -%d 0 %d]\n"
pstringd: .ASCIZ "{currentfile pix readhexstring pop }\nimage\n"
pstringe: .ASCIZ "%02x"
pstringf: .ASCIZ "\n"
pstringg: .ASCIZ "charmap`.eps"
pstringh: .ASCIZ "Cannot open postscript file %s\n"
pstringi: .ASCIZ "charmap`.pbm"
.ALIGN	2

.SECT .TEXT
posout:
	INCB (pstringg+7)
	PUSH 0644
	PUSH pstringg
	PUSH _CREAT
	SYS
	ADD  SP,6
	CMP  AX,0
	JL   9F
	MOV  (fd),AX
	PUSH pstringa
	PUSH AX
	CALL stringpr
	ADD  SP,4
	MOV  AX,TM_WID(BX)
	MOVB CL,3
	SAR  AX,CL
	MOV  (tmbytw),AX
	PUSH TM_HT(BX)
	PUSH TM_HT(BX)
	PUSH TM_WID(BX)
	PUSH TM_HT(BX)
	PUSH TM_WID(BX)
	PUSH AX
	PUSH pstringc
	PUSH buf
	PUSH _SPRINTF
	SYS
	ADD SP,18
	PUSH buf
	PUSH (fd)
	CALL stringpr
	ADD SP,4

	MOV SI,tm_ch
	MOV CX,TM_HT(BX)
6:	PUSH CX
	MOV CX,(tmbytw)
	MOV DI,buf
7:	LODSB
	PUSH AX
	PUSH pstringe
	PUSH DI
	PUSH _SPRINTF
	SYS
	ADD  SP,8
	ADD  DI,2
	LOOP 7b

	MOV  (DI),'\n'
	MOV  AX,(tmbytw)
	SHL  AX,1
	INC  AX
	PUSH AX
	PUSH buf
	PUSH (fd)
	PUSH _WRITE
	SYS
	ADD  SP,8
	POP CX
	LOOP 6b
	PUSH pstringb
	PUSH (fd)
	CALL stringpr
	PUSH _CLOSE
	SYS
	ADD  SP,6
	RET

geterr:
	PUSH err7
	PUSH _PRINTF
	SYS
	CALL ex_err

crerror:
9:	PUSH pstringg
	PUSH pstringh
	PUSH _PRINTF
	SYS
	CALL ex_err

stringpr:
	PUSH CX
	PUSH DI
	PUSH BP
	MOV  BP,SP
	MOV  AX,0
	MOV  DI,10(BP)
	MOV  SI,DI
	MOV  CX,-1
	REPNZ SCASB
	NOT  CX
	DEC  CX
	PUSH CX
	PUSH 10(BP)
	PUSH 8(BP)
	PUSH _WRITE
	SYS
	MOV  SP,BP
	POP  BP
	POP  DI
	POP  CX
	RET

	_FAKEWIN	= 64			! extra routine to open window
	_FWINOUT	= 65			! and to write onto window
		_ENKLBIT	= 1		! small window display per bit
		_DBBLBIT	= 2		! large window, square per bit
						! The prevous subroutines create
						! two x window bitmap files:
						! lEEGbITmAP and tERMbITmAP
! next we get a routine to initialise an output window. It is made with an
! unorthodox type of extra library routine. Its parameters are width and height
! of the terminal bit map.
! Do not worry about this routine at all.
.SECT .DATA
faker:	.WORD 0

.SECT .TEXT
startfak:
	INC	(faker)
	PUSH	_DBBLBIT		! Bit size two bits per bit in display
	PUSH	TM_HT(BX)		! Stack height of bitmap in bits
	PUSH	TM_WID(BX)		! Stack width of bitmap in bits
	PUSH	_FAKEWIN		! stack library call number
	SYS				! and ask for the routine
	ADD	SP,8			! clean up stack.
	RET
! Hope that the window system is smart enough to open up the window now.

tclout:
	PUSH	AX			! save registers on stack
	PUSH	BX
	PUSH	BP
	MOV	BP, SP
	MOV	BX, tm_hd		! BX indicates start of terminal record
	CMP	(faker),0
	JG	8f
	CALL	startfak
8:	PUSH	tm_ch			! Start adress of bitmap
	MOV	BX, tm_hd		! BX indicates start of terminal record
	PUSH	TM_HT(BX)		! Stack height of bitmap in bits
	PUSH	TM_WID(BX)		! Stack width of bitmap in bits
	PUSH	_FWINOUT		! stack library call number
	SYS				! and ask for the routine
	ADD	SP, 8			! clean up stack.
	MOV	SP, BP
	POP	BP			! restore registers
	POP	BX
	POP	AX
	RET
! Hope that the window system is smart enough to write onto the window now.
! end of file
