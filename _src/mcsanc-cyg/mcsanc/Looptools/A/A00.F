* A00.F
* the scalar one-point function
* this file is part of LoopTools
* written by M. Rauch
* last modified 24 Jan 06 th

#include "defs.h"


	double complex function XA00(m)
	implicit none
	DVAR m

#include "lt.h"

	double complex XA0
	external XA0

	XA00 = .25D0*m*(XA0(m) + .5D0*m)
	end

************************************************************************
* adapter code for C++

	subroutine XA00sub(res, m)
	implicit none
	double complex res
	DVAR m

	double complex XA00
	external XA00

	res = XA00(m)
	end

