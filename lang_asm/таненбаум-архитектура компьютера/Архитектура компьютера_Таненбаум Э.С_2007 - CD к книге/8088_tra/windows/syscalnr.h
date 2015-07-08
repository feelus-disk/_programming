_EXIT	   =	  1	! seven system call numbers
_READ	   =	  3
_WRITE	   =	  4
_OPEN	   =	  5
_CLOSE	   =	  6
_CREAT	   =	  8
_LSEEK	   =	 19
_GETCHAR   =	117	! five system subroutine numbers
_SPRINTF   =	121
_PUTCHAR   =	122
_SSCANF	   =	125
_PRINTF	   =	127
STDIN	   =	  0	! three initially opened file descriptors
STDOUT	   =	  1
STDERR	   =	  2

.SECT .TEXT		! Definition of section header labels
TxtSecHd:
.SECT .DATA
DatSecHd:
.SECT .TEXT
