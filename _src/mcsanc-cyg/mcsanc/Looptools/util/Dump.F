* Dump.F
* dumps the parameters and coefficients on screen
* this file is part of LoopTools
* last modified 8 Dec 05 th

#include "defs.h"


	subroutine XDumpPara(npoint, para, ldpara, origin)
	implicit none
	integer npoint, ldpara
	DVAR para(ldpara,*)
	character*(*) origin

#include "lt.h"

	integer i

	character*6 paraname(Pee,2:5)
	common /ltparanames/ paraname

	integer npara(2:5)
	data npara /Pbb, Pcc, Pdd, Pee/

#ifdef COMPLEXPARA
	if( len(origin) .gt. 1 ) print *, "C", origin, serial
#else
	if( len(origin) .gt. 1 ) print *, origin, serial
#endif

	do i = 1, npara(npoint)
	  print *, "  ", paraname(i,npoint), "=", para(1,i)
	enddo

	call flush(6)
	end

************************************************************************

	subroutine XDumpCoeff(npoint, coeff)
	implicit none
	integer npoint
	double complex coeff(*)

#include "lt.h"

	integer i

	character*8 coeffname(Nee,2:5)
	common /ltcoeffnames/ coeffname

	integer ncoeff(2:5)
	data ncoeff /Nbb, Ncc, Ndd, Nee/

	do i = 1, ncoeff(npoint)
	  print *, coeffname(i,npoint), "=", coeff(i)
	enddo

	print *, "===================================================="

	call flush(6)
	end

