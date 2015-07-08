# $Header: proto.make,v 1.5 91/10/22 14:35:13 Jacobs Exp $
CC=gcc
#				# compiler to be used for compiling Assembler Sources

# Paths:
SRC_HOME  = .

COPTIONS=-O

LDOPTIONS=#			# always passed to $(CC) when linking (none here)

SUF=o#				# suffix of files produced with $(CC) -c

DEF	=

FFLAG	=
INCL	= -I.
CFLAGS	= $(FFLAG) $(INCL) $(COPTIONS)
YFLAGS	= -d
LDFLAGS	= $(FFLAG) $(LDOPTIONS)

CSRC	= ./comm3.c ./comm4.c ./comm5.c ./bigkeywh.c \
	  ./comm6.c ./comm7.c ./comm8.c ./wr.c ./wr_bytes.c ./wr_putc.c
COBJ	= comm3.$(SUF) comm4.$(SUF) comm5.$(SUF) bigkeywh.$(SUF) \
	  comm6.$(SUF) comm7.$(SUF) comm8.$(SUF) wr.$(SUF) wr_bytes.$(SUF) wr_putc.$(SUF)
MACHSRC	= ./mach0.c ./mach1.c ./mach2.c \
	  ./mach3.c ./mach4.c ./mach5.c
COMM	= ./comm0.h ./comm1.h ./comm2.y $(CSRC)

all:	as88

install:all

clean:
	rm -f *.$(SUF) as88 # as.[cy] y.tab.h

as88:	$(COBJ) as.$(SUF)
	$(CC) $(LDFLAGS) $(COBJ) as.$(SUF) -o as88; \
	cp as88 ../bin/as88; cp as88 ../exercise/as88; cp as88 ../examples/as88

# as.y:	$(CDIR)/comm2.y
# 	$(CPP) -P -I$(MDIR) -I$h $(DEF) $(CDIR)/comm2.y >as.y
# 	-@if test -f $(MDIR)/Expect ; then cat $(MDIR)/Expect ; else echo "expect 1 shift/reduce conflict"; fi

# as.c:	as.y
# 	yacc $(YFLAGS) as.y && mv y.tab.c as.c

# y.tab.h:	as.c
$(COBJ):	y.tab.h
$(COBJ):	./comm0.h ./mach0.c
$(COBJ):	./comm1.h ./mach1.c
# as.y:		./mach2.c
# as.y:		./mach4.c
as.$(SUF):	as.c
		$(CC) -c $(CFLAGS) as.c
comm8.$(SUF):	./comm8.c
		$(CC) -c $(CFLAGS) ./comm8.c
comm8.$(SUF):	./mach5.c
comm3.$(SUF):	./comm3.c
		$(CC) -c $(CFLAGS) ./comm3.c
comm3.$(SUF):	./mach3.c
comm4.$(SUF):	./comm4.c
		$(CC) -c $(CFLAGS) ./comm4.c
comm5.$(SUF):	./comm5.c
		$(CC) -c $(CFLAGS) ./comm5.c
comm6.$(SUF):	./comm6.c
		$(CC) -c $(CFLAGS) ./comm6.c
comm7.$(SUF):	./comm7.c
		$(CC) -c $(CFLAGS) ./comm7.c
bigkeywh.$(SUF):	./bigkeywh.c
		$(CC) -c $(CFLAGS) ./bigkeywh.c
