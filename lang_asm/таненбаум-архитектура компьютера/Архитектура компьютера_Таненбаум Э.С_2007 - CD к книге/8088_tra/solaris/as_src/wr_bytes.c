/* $Id: wr_bytes.c,v 1.7 1994/06/24 11:19:19 ceriel Exp $ */
/*
 * (c) copyright 1987 by the Vrije Universiteit, Amsterdam, The Netherlands.
 * See the copyright notice in the ACK home directory, in the file "Copyright".
 */

#include "obj.h"

static int maxchunk = 16384;

/*
 * Just write "cnt" bytes to file-descriptor "fd".
 */
void
wr_bytes(fd, string, cnt)
	register char	*string;
	register long	cnt;
{

	while (cnt) {
		register int n = cnt >= maxchunk ? maxchunk : cnt;

		if (write(fd, string, n) != n)
			wr_fatal();
		string += n;
		cnt -= n;
	}
}
