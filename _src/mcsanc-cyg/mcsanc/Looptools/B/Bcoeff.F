* Bcoeff.F
* invoke the two-point tensor coefficients
* this file is part of LoopTools
* last modified 5 Dec 06 th

#include "defs.h"


	subroutine Bcoeff(para, B, ldpara)
	implicit none
	integer ldpara
	double precision para(ldpara,Pbb)
	double complex B(Nbb)

#include "lt.h"

	double complex Bcmp(Nbb)
	integer ier(Nbb), ierall, i

	goto (1, 2, 3) ibits(versionkey, KeyBget, 2)

	call Bcoeffa(para, B, ldpara, ier)
	ierall = 0
	do i = 1, Nbb
	  ierall = max(ierall, ier(i))
	enddo
	if( ierall .gt. warndigits ) then
	  call Bcoeffb(para, Bcmp, ldpara)
	  call Bcheck(para, B, Bcmp, ldpara, ier)
	endif
	return

1	call Bcoeffb(para, B, ldpara)
	return

2	call Bcoeffa(para, B, ldpara, ier)
	call Bcoeffb(para, Bcmp, ldpara)
	call Bcheck(para, B, Bcmp, ldpara, ier)
	return

3	call Bcoeffa(para, Bcmp, ldpara, ier)
	call Bcoeffb(para, B, ldpara)
	call Bcheck(para, Bcmp, B, ldpara, ier)
	end

************************************************************************

	subroutine Bcheck(para, Ba, Bb, ldpara, ier)
	implicit none
	integer ldpara, ier(Nbb)
	DVAR para(ldpara,Pbb)
	double complex Ba(Nbb), Bb(Nbb)

#include "lt.h"

	integer i
	logical ini

	character*5 name(Nbb)
	data name /"bb0", "bb1", "bb00", "bb11", "bb001", "bb111",
     &    "dbb0", "dbb1", "dbb00", "dbb11"/

	ini = .TRUE.
	do i = 1, Nbb
	  if( abs(Ba(i) - Bb(i)) .gt. maxdev*abs(Ba(i)) ) then
	    if( ini ) then
	      print *, "Discrepancy in Bget:"
	      call DumpPara(2, para, ldpara, " ")
	      ini = .FALSE.
	    endif
	    print *, name(i), " a =", Ba(i)
	    print *, name(i), " b =", Bb(i)
	    if( ier(i) .gt. errdigits ) Ba(i) = Bb(i)
	  endif
	enddo
	end

