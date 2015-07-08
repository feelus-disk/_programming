/* $Header: comm3.c,v 2.5 90/07/30 09:43:34 ceriel Exp $ */
/*
 * (c) copyright 1987 by the Vrije Universiteit, Amsterdam, The Netherlands.
 * See the copyright notice in the ACK home directory, in the file "Copyright".
 */
/* @(#)comm3.c	1.1 */
/*
 * storage allocation for variables
 */

#include	"comm0.h"

#define	extern	/* empty, to force storage allocation */

#include	"comm1.h"

#undef extern

struct outhead	outhead = {
	O_MAGIC, O_STAMP, 0
};

#include	"y.tab.h"

item_t	keytab[] = {
	0,	EXTERN,		0,		".DEFINE",
	0,	EXTERN,		0,		".EXTERN",
	0,	DOT,		0,		".",
	0,	DATA,		1,		".DATA1",
	0,	DATA,		2,		".DATA2",
	0,	DATA,		4,		".DATA4",
	0,	DATA,		1,		".BYTE",
	0,	DATA,		2,		".WORD",
	0,	DATA,		4,		".LONG",
	0,	ASCII,		0,		".ASCII",
	0,	ASCII,		1,		".ASCIZ",
	0,	ALIGN,		0,		".ALIGN",
	0,	ASSERT,		0,		".ASSERT",
	0,	SPACE,		0,		".SPACE",
	0,	COMMON,		0,		".COMM",
	0,	SECTION,	0,		".SECT",
	0,	BASE,		0,		".BASE",
	0,	SYMB,		0,		".SYMB",
	0,	SYMD,		0,		".SYMD",
	0,	LINE,		0,		".LINE",
	0,	FILe,		0,		".FILE",
#ifdef LISTING
	0,	LIST,		0,		".NOLIST",
	0,	LIST,		1,		".LIST",
#endif
#include	"mach3.c"
	0,	0,		0,		0
};
