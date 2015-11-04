* Bcoeffa.F
* the two-point tensor coefficients from FF
* this file is part of LoopTools
* last modified 7 Dec 05 th

#include "defs.h"


	subroutine XBcoeffa(para, B, ldpara, ier)
	implicit none
	integer ldpara, ier(Nbb)
	DVAR para(ldpara,Pbb)
	double complex B(Nbb)

#include "lt.h"

	DVAR p, m1, m2, dm
	double complex a0(2), b2(2), pdb0
	integer i
	logical dump
#ifdef COMPLEXPARA
	DVAR m1dm
	double complex dmp, d2mp
#endif

	p = para(1,1)
	m1 = para(1,2)
	m2 = para(1,3)

#ifdef COMPLEXPARA
	if( DIMAG(p) .eq. 0 .and.
     &      DIMAG(m1) .eq. 0 .and.
     &      DIMAG(m2) .eq. 0 ) then
	  call Bcoeffa(para, B, 2, ier)
	  return
	endif
#endif

	serial = serial + 1
	dump = ibits(debugkey, DebugB, 1) .ne. 0 .and.
     &    serial .ge. debugfrom .and. serial .le. debugto
	if( dump ) call XDumpPara(2, para, ldpara, "Bcoeffa")

	do i = 1, Nbb
	  ier(i) = 0
	enddo

	ldot = .TRUE.
	i = 0
	call Xffb0(B(bb0), p, m1, m2, i)
	ier(bb0) = i
	call Xffa0(a0(1), m1, i)
	call Xffa0(a0(2), m2, i)
	ier(bb1) = i
	call Xffb1(B(bb1), B(bb0), a0, p, m1, m2, Xfpij2, ier(bb1))
	call Xffb2p(b2, B(bb1), B(bb0), a0, p, m1, m2, Xfpij2, i)
	ier(bb00) = i
	ier(bb11) = i
	B(bb11) = b2(1)
	B(bb00) = b2(2)
	ldot = .FALSE.

	dm = m1 - m2

	if( abs(p) .lt. acc ) then
	  if( abs(dm) .lt. acc ) then
	    B(bb001) = -.5D0*B(bb00)
	  else
	    B(bb001) = -( ((m1 + m2)/6D0)**2 +
     &        m1*m2/6D0 * (B(bb0) + 1/3D0) + 
     &        (dm - m2)/3D0 * B(bb00) )/dm
	  endif
	else
	  B(bb001) = .125D0*( 2*m1*B(bb1) - a0(2) +
     &      (p + dm)*(B(bb11) + 1/6D0) - .5D0*(m1 + m2) )
	endif

	call Xffdb0(B(dbb0), pdb0, p, m1, m2, ier(dbb0))

#ifdef COMPLEXPARA
	if( abs(p) .lt. acc ) then
	  if( abs(dm) .lt. acc ) then
	    B(bb111) = -.25D0*B(bb0)
	  else
	    m1dm = m1/dm
	    B(bb111)= 3/16D0 + .25D0*a0(2)/dm*(m1dm + 1) +
     &        .5D0*m1dm*(m1dm*(B(bb1) - .5D0) - 1/6D0)
	  endif
	else
	  B(bb111) = -.25D0*( a0(2) + 2*m1*B(bb1) +
     &      (p + dm)*(3*B(bb11) + 1/6D0) - .5D0*(m1 + m2) )/p
	endif

	B(dbb1) = .5D0/p*(
     &    (a0(2) - a0(1) + dm*B(bb0))/p -
     &    (p + dm)*B(dbb0) )

	dmp = (m1 - m2)/p
	d2mp = (m1 - 2*m2)/p
	B(dbb11) = 1/3D0*(
     &    ( (.5D0*(m1 + m2) +
     &        (2*dmp + 1)*a0(1) - (2*dmp + 2)*a0(2))/p -
     &      (d2mp + 2*dmp**2)*B(bb0) )/p +
     &    (d2mp + dmp**2 + 1)*B(dbb0) )
#else
	call ffxb111(B(bb111), p, m1, m2, ier(bb111))
	call ffxdb1(B(dbb1), p, m1, m2, ier(dbb1))
	call ffxdb11(B(dbb11), p, m1, m2, ier(dbb11))
#endif

	B(dbb00) = 1/6D0*( 2*m1*B(dbb0) + B(bb1) +
     &    (p + dm)*B(dbb1) - 1/3D0 )

	if( dump ) call DumpCoeff(2, B)
	end

