* Bcoeffb.F
* the two-point tensor coefficients from Ansgar Denner's bcanew.f,
* adapted to the conventions of LoopTools
* this file is part of LoopTools
* last modified 5 Dec 06 th

#include "defs.h"


	subroutine Bcoeffb(para, B, ldpara)
	implicit none
	integer ldpara
	double precision para(ldpara,Pbb)
	double complex B(Nbb)

#include "lt.h"

	double complex fpv, yfpv, fth, xlogx, A0b
	external fpv, yfpv, fth, xlogx, A0b

	double precision p, m1, m2
	double precision minacc, dm
	double complex x1, x2, y1, y2, r
	double complex mu, f1, f2, g1, g2
	integer sel
	logical dump

	p = para(1,1)
	m1 = para(1,2)
	m2 = para(1,3)

	serial = serial + 1
	dump = ibits(debugkey, DebugB, 1) .ne. 0 .and.
     &    serial .ge. debugfrom .and. serial .le. debugto
	if( dump ) call DumpPara(2, para, ldpara, "Bcoeffb")

	minacc = acc*(m1 + m2)
	dm = m1 - m2

* general case
	if( abs(p) .gt. minacc ) then
	  r = sqrt(DCMPLX(p*(p - m1 - m2) -
     &      m1*(p - dm) - m2*(p + dm)))
	  x1 = .5D0*(p + dm + r)/p
	  x2 = .5D0*(p + dm - r)/p
	  if( abs(x2) .gt. abs(x1) ) then
	    x1 = m1/(p*x2)
	  else if( abs(x1) .gt. abs(x2) ) then
	    x2 = m1/(p*x1)
	  endif
	  x1 = x1 + abs(p*x1)/p*eps*cI
	  x2 = x2 - abs(p*x2)/p*eps*cI

	  y2 = .5D0*(p - dm + r)/p
	  y1 = .5D0*(p - dm - r)/p
	  if( abs(y2) .gt. abs(y1) ) then
	    y1 = m2/(p*y2)
	  else if( abs(y1) .gt. abs(y2) ) then
	    y2 = m2/(p*y1)
	  endif
	  y1 = y1 - abs(p*y1)/p*eps*cI
	  y2 = y2 + abs(p*y2)/p*eps*cI

	  if( abs(y1) .gt. .5D0 .and. abs(y2) .gt. .5D0 ) then
	    mu = log(m2/mudim) - delta
	    B(bb0) = -(mu + fpv(1, x1, y1) + fpv(1, x2, y2))
	    B(bb1) = 1/2D0*(mu + fpv(2, x1, y1) + fpv(2, x2, y2))
	    B(bb11) = -1/3D0*(mu + fpv(3, x1, y1) + fpv(3, x2, y2))
	    B(bb111) = 1/4D0*(mu + fpv(4, x1, y1) + fpv(4, x2, y2))
	  else if( abs(x1) .lt. 10 .and. abs(x2) .lt. 10 ) then
	    mu = log(p/mudim*(1 - cI*eps)) - delta
	    g1 = xlogx(y1)
	    f1 = xlogx(-x1) - g1 + 1
	    g2 = xlogx(y2)
	    f2 = xlogx(-x2) - g2 + 1
	    B(bb0) = -(mu - f1 - f2)
	    f1 = x1*f1 - g1 + 1/2D0
	    f2 = x2*f2 - g2 + 1/2D0
	    B(bb1) = 1/2D0*(mu - f1 - f2)
	    f1 = x1*f1 - g1 + 1/3D0
	    f2 = x2*f2 - g2 + 1/3D0
	    B(bb11) = -1/3D0*(mu - f1 - f2)
	    f1 = x1*f1 - g1 + 1/4D0
	    f2 = x2*f2 - g2 + 1/4D0
	    B(bb111) = 1/4D0*(mu - f1 - f2)
	  else if( abs(x1) .gt. .5D0 .and. abs(x2) .gt. .5D0 ) then
	    mu = log(m1/mudim) - delta +
     &        fth(1, x1, y1) + fth(1, x2, y2)
	    B(bb0) = -mu
	    mu = mu + fth(2, x1, y1) + fth(2, x2, y2)
	    B(bb1) = 1/2D0*mu
	    mu = mu + fth(3, x1, y1) + fth(3, x2, y2)
	    B(bb11) = -1/3D0*mu
	    mu = mu + fth(4, x1, y1) + fth(4, x2, y2)
	    B(bb111) = 1/4D0*mu
	  else
	    print *, "Bcoeffb not defined for"
	    print *, "  p  =", p
	    print *, "  m1 =", m1
	    print *, "  m2 =", m2
	    B(bb0) = nan
	    B(bb1) = nan
	    B(bb11) = nan
	    B(bb111) = nan
	  endif

	  B(bb00) = ((p + dm)*B(bb1) +
     &      2*m1*B(bb0) + A0b(m2) + m1 + m2 - p/3D0)/6D0

	  B(bb001) = .125D0*( 2*m1*B(bb1) - A0b(m2) +
     &      (p + dm)*(B(bb11) + 1/6D0) - .5D0*(m1 + m2) )

	  if( abs(x1 - x2) .gt. acc*abs(x1 + x2) ) then
	    B(dbb11) = (yfpv(3, x2, y2) - yfpv(3, x1, y1))/r
	    sel = 1
	  else if( abs(x1) .gt. 10 ) then
	    B(dbb11) = -DBLE((3/4D0 + (3 - 4*x1)*fpv(4, x1, y1))/
     &        x1**2)/p
	    sel = 2
	  else if( abs(y1) .gt. acc ) then
	    B(dbb11) = -DBLE(4/3D0 + (3 - 4*x1)*fpv(2, x1, y1))/p
	    sel = 3
	  else
	    B(dbb11) = nan
	  endif

	  if( m1*m2 .eq. 0 .and.
     &        abs(p - m1 - m2) .lt. acc ) then
* IR divergent case
            B(dbb0) = -(1 + .5D0*log(lambda/p))/p
	  else if( sel .eq. 1 ) then
	    B(dbb0) = (yfpv(1, x2, y2) - yfpv(1, x1, y1))/r
	  else if( sel .eq. 2 ) then
	    B(dbb0) = -DBLE((.5D0 + (1 - 2*x1)*fpv(2, x1, y1))/
     &        x1**2)/p
	  else if( sel .eq. 3 ) then
	    B(dbb0) = -DBLE(2 + (1 - 2*x1)*fpv(0, x1, y1))/p
	  else
	    B(dbb0) = nan
	  endif

          if( m2 .eq. 0 .and. abs(p - m1) .lt. acc ) then
* IR divergent case
	    B(dbb1) = .5D0*(3 + log(lambda/p))/p
	  else if( sel .eq. 1 ) then
	    B(dbb1) = (yfpv(2, x1, y1) - yfpv(2, x2, y2))/r
	  else if( sel .eq. 2 ) then
	    B(dbb1) = DBLE((2/3D0 + (2 - 3*x1)*fpv(3, x1, y1))/
     &        x1**2)/p
	  else if( sel .eq. 3 ) then
	    B(dbb1) = DBLE(3/2D0 + (2 - 3*x1)*fpv(1, x1, y1))/p
	  else
	    B(dbb1) = nan
	  endif

* zero momentum
	else if( abs(dm) .gt. minacc ) then
	  x2 = m1/dm*(1 - cI*eps)
	  y2 = -m2/dm*(1 - cI*eps)
	  if( abs(y2) .gt. .5D0 ) then
	    mu = log(m2/mudim) - delta
	    B(bb0) = -(mu + fpv(1, x2, y2))
	    B(bb1) = 1/2D0*(mu + fpv(2, x2, y2))
	    B(bb11) = -1/3D0*(mu + fpv(3, x2, y2))
	    B(bb111) = 1/4D0*(mu + fpv(4, x2, y2))
	    B(bb00) = (2*(m1*B(bb0) + A0b(m2)) + m1 + m2)/8D0
	  else
	    mu = log(m1/mudim) - delta
	    f1 = fpv(1, y2, x2)
	    B(bb0) = -(mu + f1)
	    B(bb1) = 1/2D0*(mu + (1 + x2)*f1 + 1/2D0)
	    B(bb11) = -1/3D0*(mu - (1 + x2*(1 + x2))*yfpv(0, x2, y2) -
     &        x2*(x2 + 1/2D0) - 1/3D0)
	    B(bb111) = 1/4D0*(mu -
     &        (1 + x2*(1 + x2*(1 + x2)))*yfpv(0, x2, y2) -
     &        x2*(x2*(x2 + 1/2D0) + 1/3D0) - 1/4D0)
	    B(bb00) = (2*(m2*B(bb0) + A0b(m1)) + m1 + m2)/8D0
	  endif

	  B(bb001) = -( ((m1 + m2)/6D0)**2 +
     &      m1*m2/6D0 * (B(bb0) + 1/3D0) +
     &      (dm - m2)/3D0 * B(bb00) )/dm

	  if( abs(x2) .lt. 10 ) then
	    B(dbb0) = (1/2D0 + yfpv(1, x2, y2))/dm
	    B(dbb1) = -(1/3D0 + yfpv(2, x2, y2))/dm
	    B(dbb11) = (1/4D0 + yfpv(3, x2, y2))/dm
	  else
	    B(dbb0) = (1/2D0 + yfpv(2, x2, y2))/m1
	    B(dbb1) = -(1/3D0 + yfpv(3, x2, y2))/m1
	    B(dbb11) = (1/4D0 + yfpv(4, x2, y2))/m1
	  endif
	else
	  mu = log(m2/mudim) - delta
	  B(bb0) = -mu
	  B(bb1) = 1/2D0*mu
	  B(bb11) = -1/3D0*mu
	  B(bb111) = 1/4D0*mu
	  B(bb00) = .5D0*m1*(1 - mu)
	  B(bb001) = -.5D0*B(bb00)
	  B(dbb0) = 1/6D0/m1
	  B(dbb1) = -1/12D0/m1
	  B(dbb11) = 1/20D0/m1
	endif

	B(dbb00) = 1/6D0*( 2*m1*B(dbb0) + B(bb1) +
     &    (p + dm)*B(dbb1) - 1/3D0 )

	if( dump ) call DumpCoeff(2, B)
	end

************************************************************************

	double complex function fpv(n, x, y)
	implicit none
	integer n
	double complex x, y

#include "lt.h"

	double complex xm
	integer m

	if( abs(x) .lt. 5 ) then
	  if( n .eq. 0 ) then
	    fpv = -log(-y/x)
	  else if( abs(x) .lt. acc ) then
	    fpv = -1D0/n
	  else
	    xm = -log(-y/x)
	    do m = 1, n
	      xm = x*xm - 1D0/m
	    enddo
	    fpv = xm
	  endif
	else
	  fpv = 0
	  xm = 1
	  do m = 1, 50
	    xm = xm/x
	    fpv = fpv + xm/(m + n)
	    if( abs(xm) .lt. precx*abs(fpv) ) return
	  enddo
	endif
	end

************************************************************************

	double complex function yfpv(n, x, y)
	implicit none
	integer n
	double complex x, y

	double complex fpv
	external fpv

	if( abs(y) .eq. 0 ) then
	  yfpv = 0
	else
	  yfpv = y*fpv(n, x, y)
	endif
	end

************************************************************************

	double complex function fth(n, x, y)
	implicit none
	integer n
	double complex x, y

#include "lt.h"

	double complex fpv
	external fpv

	double complex xm
	integer m

	if( abs(x) .gt. 1D4 ) then
	  xm = 1
	  fth = 0
	  do m = n, 30 + n
	    xm = xm/x
	    fth = fth - xm/(m*(m + 1))
	    if( abs(xm) .lt. precx*abs(fth) ) return
	  enddo
	else
	  fth = fpv(1, y, x)
	  do m = 1, n - 1
	    fth = x*fth + 1D0/(m*(m + 1))
	  enddo
	endif
	end

************************************************************************

	double complex function xlogx(x)
	implicit none
	double complex x

	if( abs(x) .eq. 0 ) then
	  xlogx = 0
	else
	  xlogx = x*log(x)
	endif
	end

