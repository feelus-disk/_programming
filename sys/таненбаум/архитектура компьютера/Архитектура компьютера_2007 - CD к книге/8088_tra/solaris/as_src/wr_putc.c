/* $Id: wr_putc.c,v 1.7 1994/06/24 11:19:30 ceriel Exp $ */
/*
 * (c) copyright 1987 by the Vrije Universiteit, Amsterdam, The Netherlands.
 * See the copyright notice in the ACK home directory, in the file "Copyright".
 */
#include "obj.h"

extern int __sectionnr;

void
wr_putc(ch)
{
	register struct fil *ptr = &__parts[PARTEMIT+getsect(__sectionnr)];

	if (ptr->cnt == 0) __wr_flush(ptr);
	ptr->cnt--; *ptr->pnow++ = ch;
}
