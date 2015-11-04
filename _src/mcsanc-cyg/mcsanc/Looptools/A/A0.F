* A0.F
* the scalar one-point function
* this file is part of LoopTools
* last modified 20 Dec 06 th

#include "defs.h"


	double complex function XA0(m)
	implicit none
	DVAR m

#include "lt.h"

	double complex XA0b
	external XA0b

	double complex res(0:1)
	integer key, ier

	key = ibits(versionkey, KeyA0, 2)

	if( key .ne. 1 ) then
	  ier = 0
	  call Xffa0(res(0), m, ier)
	  if( ier .gt. warndigits ) key = ior(key, 2)
	endif

	if( key .ne. 0 ) then
	  res(1) = XA0b(m)
	  if( key .gt. 1 .and.
     &        abs(res(0) - res(1)) .gt. maxdev*abs(res(0)) ) then
#ifdef COMPLEXPARA
	    print *, "Discrepancy in CA0:"
	    print *, "    m =", m
	    print *, "A0C a =", res(0)
	    print *, "A0C b =", res(1)
#else
	    print *, "Discrepancy in A0:"
	    print *, "   m =", m
	    print *, "A0 a =", res(0)
	    print *, "A0 b =", res(1)
#endif
	  endif
	endif

	XA0 = res(iand(key, 1))
	end

************************************************************************
* adapter code for C++

	subroutine XA0sub(res, m)
	implicit none
	double complex res
	DVAR m

	double complex XA0
	external XA0

	res = XA0(m)
	end

************************************************************************
* this routine is adapted from Ansgar Denner's bcanew.f
* to the conventions of LoopTools

	double complex function XA0b(m)
	implicit none
	DVAR m

#include "lt.h"

	if( m .eq. 0 ) then
	  XA0b = 0
	else
	  XA0b = m*(1 - log(m/mudim) + delta)
	endif
	end

