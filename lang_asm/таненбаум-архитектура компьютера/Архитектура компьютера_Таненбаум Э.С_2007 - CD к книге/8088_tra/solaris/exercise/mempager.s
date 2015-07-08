!		MEMORY MANAGER
!
! The aim of this exercise is to program a simple memory paging system.
! In the original paging systems the addressable memory is larger than
! the physical memory of the system. The principles of paging can also
! be used in systems with an ultrafast cash and a slower core memory.
! 
! It goes without saying, that a practical paging problem is too large
! to be discussed in a simple programming exercise and so we will 
! show how to handle a tiny system with an adressable memory of 65536
! bytes and a physical memory of only 4096 bytes. The virtual memory
! system is kept in a file called "mempager.mem" and both this memory
! on file and the physical memory is divided into pages of 256 bytes.
! The physical memory is kept in the BSS segment in the array "cormem",
! The virtual memory contains 256 pages, and the "cormem" contains 16
! pages. 
!
! If a memory access is required, then the virtual page which contains
! that address must be mapped onto a physical page, and the actual
! access is performed on the physical address.
! If the indicated page is not yet in the physical memory, then the
! virtual page in the file has to be copied in a page of the "cormem"
! array. The obvious way to do that is to perform a "read" system
! call of 256 bytes into a buffer which is a subset of the "cormem"
! array, and with a file descriptor representing the virtual memory file.
! If the memory access "writes" the indicated address, then the contents
! of the core array is different from the page in the file, and in
! that case the page is called "dirty". Dirty pages have to be written
! back eventually to the corresponding virtual pages in the file.
!
! This file "mempager.s" already contains two routines to facilitate
! the copying of the file pages to the core pages and conversely.
! The subroutine "memrd" can be called to copy from the file to the
! "cormem" array, and "memwrt" copies from "cormem" to "mempager.mem".
! Both those routines expect the virtual page number on top of the stack,
! and the page number in "cormem" is the next argument of the stack.
!
! It goes without saying, that a paging system needs some tables for
! the administration, and one of the most important parts of this
! exercises is to write routines to keep the tables consistent with
! the actual situation.
! For a fast performance it is sensible to define two tables, "filtab"
! and "cortab" in the binary storage section. It can be seen in the
! "filtab"  whether a page of the file is copied in core, and if so,
! at what page. The "cortab" tells us to which virtual page a given
! page in core corresponds.
! Since there are only 256 virtual pages, an entry in the "cortab" can
! consist of a single byte. An entry of the "filtab" also consists
! of a single byte, and since there are only 16 core pages, there are
! sufficiently many unused bits to register whether a page is copied
! in core or not, whether it is "dirty", and whether it is ever used.
! In order to be explicit, a single entry in the "filtab" consists of
! eight bits which can be filled according to the following scheme:
!       _____ _____ _____ _____ _____ _____ _____ _____
!      |inout|dirty|used | ??? | core|page | num | ber |
!      |_____|_____|_____|_____|_____|_____|_____|_____|
!
! If a free core page is read from the file, the the following message
! must be written onto standard output:
!
! 	<Core page %d loaded with file page %d.>
!
! If the core page was already in use before the message must be:
!
! 	<Core page %d was file page %d is replaced by file page %d.>
!
! The page replacement policy is "first in first out" (round robin),
! i.e. we first load core page 0, then 1, until 15, and in stead of
! page 16, which does not exist, we replace page 0 en next page 1 etc.
!
! The simulator program expects its input on a file "mempager.in", which
! consists of lines which meet the following specification:
!
! <octal address> <space> <r/w> [(in case of w) <space> <byte>] <\n>
!
! in which <r/w> is either an "r" for reading, or a "w" for writing.
! The part between square brackets is meant to define the byte to be
! written in case of a "w".
!
! The octal address is interpreted in the "mempage.mem" file, and so
! it is a virtual address. The page on which it resides has to be in
! the physical address space in "cormem" in order to be processed.
! If a copy of that page is not in "cormem" it must be copied into
! the physical array. If there is no free page in core, then some page
! needs to be discarded in the "cormem" array. If that page happens to
! be dirty, it has to be written back to the "mempager.mem" file before
! the new page is loaded. After each  page switch the two tables "cortab"
! and "filtab" have to be adapted to the new situation. 
! Now the needed page is in core, and the indicated memory location can
! be found by replacing the virtual page number by the corresponding core
! page number in order to obtain the necessary physical address in "cormem".
! 
! In case of an "r" the octal address is replaced by the physical address
! in the indicated way. The byte value can be retrieved, and it must be
! written onto standard ouput according to the following format:
! output 
! 	<Read byte %c, in octal %o on file position %o, on core page %d.>
! To this end the system subroutine "printf" can be used, which has besides
! the format two times the numerical byte value, the octal address, and the
! core page number as its arguments.
! If the character which is found is not printable, the first argument
! must be replaced by the numerical value of an ascii-dot, "." in order to
! avoid that the output gets clobbered by the %c in the printf call.
!
! In case of a write command "w" the remainder of the line is interpreted
! as a byte value, which must be put at the indicated virtual address.
! this can either be a printable character, or a value indicated by a
! backslash escape. Printable characters have octal values between 041 and
! 176, the backslash escape values are  "\\" for the backslash itself, 
! "\n" for a new line, "\r" for a carriage return, "\b" for a back space,
! "\t" for a tab, "\s" for a space character. Arbitrary byte values can
! be inserted with a "\xxx" in which the "xxx" contain any octal value
! between 000 an 377.
!
!
! At the end of the program the statistics of the process must be
! printed on standard output. We expect for every virtual page that
! was in core during the run a line, which gives whether it is in or
! out of core, at the the end of the run, and the last core page
! onto which it was loaded.
! Moreover, the total number of read actions, the total number of
! write actions, the total number of pages loaded, and the total
! number of dirty pages must be written onto standard output.
!
!
!		SUMMARY OF INSTRUCTIONS FOR THE EXERCISE:
!
!  1	Make two tables "filtab" and "cortab" in .SECT.BSS for
!		the administration.
!  2	Make a subroutine which reads a line of input and split it
!		into the octal address, and the instruction.
!		In case of a write, determine the byte value of the
!		indication at the remainder of the line.
!  3	If an error is encountered in an input line give a sensible
!		error message and discard the line.
!  4	Make a routine which reads the tables and determines whether
!		the required page is in core.
!  5	Make a subroutine to bring a virtual page in core, saving the
!		old core page if it is dirty. Adapt the tables to the
!		new situation in the cormem array.
!  6	Give the applicable page loading message or page exchange 
!		message at every page change.
!  7	Obtain the byte value of the octal address in case of a read
!		and print the requred line on the output.
!  8	Obtain the byte value in case of a write and put it in
!		physical memory, set the dirty bit in the page table.
!  9	Write all dirty pages back to vertual memory if the end of the
!		input file is encountered.
! 10	Give the required statistics at the end of input and quit.
!
!
!		HINTS
!
! BSS must contain a counter which tells how many pages are loaded
! at every stage. If this counter is AND-ed with the constant 15 (or
! 0Xf in hexadecimal) then we get the next core page number to be 
! loaded or replaced. In the same way, if some file page is swapped
! out of core, then the last page in which it was loaded can be
! found by AND-ing the corresponding entry in the file table with 15.
! So in replacing a page this entry can be AND-ed with 47 (0x2f), 
! which resets the dirty bin and the in core bit, but keeps the
! used bit and the core page number onto which it was loaded.
!
! The original file "mempager.mem" consists of 1024 lines of printable
! pritable characters. It is sensible to copy this file to a file
! e.g. "mempager.saf" before working on the exercise. After the run
! of the program the two copies can be compared, in order to debug
! the program. This file is also valuable if several input files
! are used successively.
!
!

.sect .text
startoff:
	
	call	initfil			! Initfil opens the page file

! Here you can put a call to your main routine

	call	closer			! close routine with an exit call

closer:	push	(fildes)		! file descriptor page file before close
	push	(close)			! close call number on stack
	sys				! closes the page file
	add	sp,4
	push	(null)			! null for success in exit call
	push	(exit)			! push call number exit
	sys				! back to command level

initfil:
	push	ax			! Save registers
	push	(two)			! Open for read and write
	mov	ax,memfil
	push	ax
	push	(open)
	sys				! the actual open call
	cmp	ax,0
	jl	erropen
	mov	(fildes),ax		! save the file descriptor
	add	sp,6			! Stack cleanup
	pop	ax			! Reset registers 
	ret

memwrt:
					! Before the memwrt call it is
					! assumed that first the core buffer
					! page number is pushed onto the stack
					! and after that the file page number
					! is pushed. The routine will write
					! the core page over the indicated
					! file page. The old file page is lost.
	push	bp			! save old base pointer link
	mov	bp,sp			! prepare new base pointer
	push	ax			! save used registers during subroutine
	push	dx			! safe DX because lseek returns double
	xor	ax,ax			! zero in AX
	push	ax			! lseek call from start of file
	push	ax			! lseek uses a long; put 0 in high byte
	movb	ah,4(bp)		! file page number in high byte AX
	push	ax			! push AX before the call
	push	(fildes)		! push file descriptor
	push	(lseek)			! push seek call number
	sys				! the actual lseek system call
	cmp	dx,0
	jl	wrterr
	add	sp,10
	push	(pgsize)		! number of bytes to be written
	mov	ax,cormem
	addb	ah,6(bp)		! fetch buffer page number
	push	ax			! push buffer with offset
	push	(fildes)		! push file descriptor
	push	(write)
	sys				! the actual read system call
	cmp	ax,(pgsize)
	jne	wrterr
	add	sp,8
	pop	dx
	pop	ax
	pop	bp			! base pointer link restored
	ret

memrd:
					! Before the memrd call it is
					! assumed that first the core buffer
					! page number is pushed onto the stack
					! and after that the file page number
					! is pushed. The routine will write
					! the file page over the indicated
					! core page. The old core page is lost.
	push	bp			! base pointer link
	mov	bp,sp			! base pointer zetten
	push	ax			! registers sparen over de routine
	push	dx			! safe voor call met dubbel
	xor	ax,ax			! zero in AX
	push	ax			! lseek call from start of file
	push	ax			! lseek asks for a long with high word 0
	movb	ah,4(bp)		! file page number in high byte AX
	push	ax			! op de stack voor de call
	push	(fildes)		! push file descriptor
	push	(lseek)			! push seek call number
	sys				! the actual seek system call
	cmp	dx,0
	jl	rderr
	add	sp,10
	push	(pgsize)		! Push number of bytes to be read
	mov	ax,cormem
	addb	ah,6(bp)		! push buffer page number 
	push	ax			! push buffer with offset
	push	(fildes)		! push file descriptor 
	push	(read)
	sys				! the actual read system call
	cmp	ax,(pgsize)
	jne	wrterr
	add	sp,8
	pop	dx
	pop	ax
	pop	bp			! base pointer link restored
	ret


wrterr:
	mov	ax,wrterro
	push	ax
	push	(printf)
	sys
	add	sp,4
	jmp	closer

rderr:
	mov	ax,rderro
	push	ax
	push	(printf)
	sys
	add	sp,4
	jmp	closer

erropen:
	mov	ax,openerro
	push	ax
	push	(printf)
	sys
	add	sp,4
	push	(one)
	push	(exit)
	sys


! Here you can put your own subroutines

.sect .data

null:	.word 0
one:
exit:	.word 1
two:	.word 2
read:	.word 3
four:
write:	.word 4
open:	.word 5
close:	.word 6
eight:	.word 8
lseek:	.word 19
getchr: .word 117
sscanf: .word 125	! Sscanf can be used to convert octal ascii strings to
			! integers.
printf: .word 127
pgsize:	.word 256

			! Details of system subroutines in UNIX manual I-(3).

openerro:	.asciz	"Cannot open file page\n"
wrterro:	.asciz	"File write from core buffer failed\n"
rderro:		.asciz	"File read to core buffer failed\n"
memfil:		.asciz  "mempager.mem"
.align 2

! Here you can put your initialised data

.sect .bss
	fildes:	.space 2
	cormem: .space 4096

! Here you can put your uninitialised data, with the core administration array
!		and the page administration array
