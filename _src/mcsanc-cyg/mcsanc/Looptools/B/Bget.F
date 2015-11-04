* Bget.F
* retrieve the two-point tensor coefficients
* this file is part of LoopTools
* last modified 28 Oct 05 th

#include "defs.h"


	integer function XBget(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer cachelookup
	external cachelookup, XBcoeff

	DVAR para(Pbb)

	para(1) = p
	para(2) = m1
	para(3) = m2

	XBget = cachelookup(para, Bval(1,0), XBcoeff, RC*Pbb, Nbb)
	end

************************************************************************

	double complex function XB0i(i, p, m1, m2)
	implicit none
	integer i
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	integer b

	b = XBget(p, m1, m2)
	XB0i = Bval(i,b)
	end

************************************************************************

	double complex function XB0(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	XB0 = Bval(bb0,XBget(p, m1, m2))
	end

************************************************************************

	double complex function XB1(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	XB1 = Bval(bb1,XBget(p, m1, m2))
	end

************************************************************************

	double complex function XB00(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	XB00 = Bval(bb00,XBget(p, m1, m2))
	end

************************************************************************

	double complex function XB11(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	XB11 = Bval(bb11,XBget(p, m1, m2))
	end

************************************************************************

	double complex function XB001(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	XB001 = Bval(bb001,XBget(p, m1, m2))
	end

************************************************************************

	double complex function XB111(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	XB111 = Bval(bb111,XBget(p, m1, m2))
	end

************************************************************************

	double complex function XDB0(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	XDB0 = Bval(dbb0,XBget(p, m1, m2))
	end

************************************************************************

	double complex function XDB1(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	XDB1 = Bval(dbb1,XBget(p, m1, m2))
	end

************************************************************************

	double complex function XDB00(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	XDB00 = Bval(dbb00,XBget(p, m1, m2))
	end

************************************************************************

	double complex function XDB11(p, m1, m2)
	implicit none
	DVAR p, m1, m2

#include "lt.h"

	integer XBget
	external XBget

	XDB11 = Bval(dbb11,XBget(p, m1, m2))
	end

