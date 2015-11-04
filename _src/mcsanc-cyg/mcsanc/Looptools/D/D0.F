* D0.F
* the scalar four-point function
* this file is part of LoopTools
* last modified 10 Apr 06 th

#include "defs.h"


	double complex function D0(p1, p2, p3, p4, p1p2, p2p3,
     &    m1, m2, m3, m4)
	implicit none
	double precision p1, p2, p3, p4, p1p2, p2p3
	double precision m1, m2, m3, m4

#include "lt.h"

	double complex D0b
	external D0b

	double complex res(0:1)
	double precision xpi(13)
	integer key, ier

	ier = 0
	key = ibits(versionkey, KeyD0, 2)

	if( key .ne. 1 ) then
	  xpi(1) = m1
	  xpi(2) = m2
	  xpi(3) = m3
	  xpi(4) = m4
	  xpi(5) = p1 
	  xpi(6) = p2
	  xpi(7) = p3
	  xpi(8) = p4
	  xpi(9) = p1p2
	  xpi(10) = p2p3
	  xpi(11) = 0
	  xpi(12) = 0
	  xpi(13) = 0
	  call ffxd0(res(0), xpi, ier)
	  if( ier .gt. warndigits ) then
	    ier = 0
	    call ffxd0r(res(0), xpi, ier)
	    if( ier .gt. warndigits ) key = ior(key, 2)
	    if( ier .ge. errdigits ) key = ior(key, 3)
	  endif
	endif

	if( key .ne. 0 ) then
	  res(1) = D0b(p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4)
	  if( key .gt. 1 .and.
     &        abs(res(0) - res(1)) .gt. maxdev*abs(res(0)) ) then
	    print *, "Discrepancy in D0:"
	    print *, "  p1   =", p1
	    print *, "  p2   =", p2
	    print *, "  p3   =", p3
	    print *, "  p4   =", p4
	    print *, "  p1p2 =", p1p2
	    print *, "  p2p3 =", p2p3
	    print *, "  m1   =", m1
	    print *, "  m2   =", m2
	    print *, "  m3   =", m3
	    print *, "  m4   =", m4
	    print *, "D0 a   =", res(0)
	    print *, "D0 b   =", res(1)
	    if( ier .gt. errdigits ) res(0) = res(1)
	  endif
	endif

	D0 = res(iand(key, 1))
	end

************************************************************************
* adapter code for C++

	subroutine d0sub(res, p1, p2, p3, p4, p1p2, p2p3,
     &    m1, m2, m3, m4)
	implicit none
	double complex res
	double precision p1, p2, p3, p4, p1p2, p2p3
	double precision m1, m2, m3, m4

	double complex D0
	external D0

	res = D0(p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4)
	end

************************************************************************
* this routine is adapted from Ansgar Denner's bcanew.f
* to the conventions of LoopTools;
* it is used for double-checking the results of FF
* M. Rauch: implemented the log branch cuts for k13 < 2
* (from Denner, Nierste, Scharf; Nucl Phys B367 (1991) 637)

#define AddEps(k) k*DCMPLX(1D0, -sign(eps, k))
#define k2r(k) (.5D0*k*(1 + sqrt(DCMPLX((1 - 2/k)*(1 + 2/k)))))

	double complex function D0b(p1, p2, p3, p4, p1p2, p2p3,
     &    m1, m2, m3, m4)
	implicit none
	double precision p1, p2, p3, p4, p1p2, p2p3
	double precision m1, m2, m3, m4

#include "lt.h"

	double complex D0ir, D0m0, D0reg
	external D0ir, D0m0, D0reg

* check IR cases first
	if( m1 .eq. 0 ) then
	  if( abs(p1 - m2) + abs(p4 - m4) .lt. acc ) then
	    D0b = D0ir(p1, p2, p3, p4, p1p2, p2p3, m3)
	    return
	  endif
	  if( abs(p1 - m2) + abs(p1p2 - m3) .lt. acc ) then
	    D0b = D0ir(p1, p2p3, p3, p1p2, p4, p2, m4)
	    return
	  endif
	  if( abs(p4 - m4) + abs(p1p2 - m3) .lt. acc ) then
	    D0b = D0ir(p1p2, p2, p2p3, p4, p1, p3, m2)
	    return
	  endif
	endif

	if( m2 .eq. 0 ) then
	  if( abs(p1 - m1) + abs(p2 - m3) .lt. acc ) then
	    D0b = D0ir(p1, p4, p3, p2, p2p3, p1p2, m4)
	    return
	  endif
	  if( abs(p1 - m1) + abs(p2p3 - m4) .lt. acc ) then
	    D0b = D0ir(p1, p1p2, p3, p2p3, p2, p4, m3)
	    return
	  endif
	  if( abs(p2 - m3) + abs(p2p3 - m4) .lt. acc ) then
	    D0b = D0ir(p2, p1p2, p4, p2p3, p1, p3, m1)
	    return
	  endif
	endif

	if( m3 .eq. 0 ) then
	  if( abs(p2 - m2) + abs(p3 - m4) .lt. acc ) then
	    D0b = D0ir(p2, p1, p4, p3, p1p2, p2p3, m1)
	    return
	  endif
	  if( abs(p2 - m2) + abs(p1p2 - m1) .lt. acc ) then
	    D0b = D0ir(p2, p2p3, p4, p1p2, p3, p1, m4)
	    return
	  endif
	  if( abs(p3 - m4) + abs(p1p2 - m1) .lt. acc ) then
	    D0b = D0ir(p1p2, p1, p2p3, p3, p2, p4, m2)
	    return
	  endif
	endif

	if( m4 .eq. 0 ) then
	  if( abs(p4 - m1) + abs(p3 - m3) .lt. acc ) then
	    D0b = D0ir(p3, p2, p1, p4, p2p3, p1p2, m2)
	    return
	  endif
	  if( abs(p4 - m1) + abs(p2p3 - m2) .lt. acc ) then
	    D0b = D0ir(p2p3, p2, p1p2, p4, p3, p1, m3)
	    return
	  endif
	  if( abs(p3 - m3) + abs(p2p3 - m2) .lt. acc ) then
	    D0b = D0ir(p3, p1p2, p1, p2p3, p4, p2, m1)
	    return
	  endif
	endif

	if( m1 .eq. 0 ) then
	  D0b = D0m0(p3, p4, p1, p2, p1p2, p2p3, m3, m4, m2)
	else if( m2 .eq. 0 ) then
	  D0b = D0m0(p4, p1, p2, p3, p2p3, p1p2, m4, m1, m3)
	else if( m3 .eq. 0 ) then
	  D0b = D0m0(p1, p2, p3, p4, p1p2, p2p3, m1, m2, m4)
	else if( m4 .eq. 0 ) then
	  D0b = D0m0(p2, p3, p4, p1, p2p3, p1p2, m2, m3, m1)
	else
	  D0b = D0reg(p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4)
	endif
	end

************************************************************************

	double complex function D0ir(p1, p2, p3, p4, p1p2, p2p3, m3)
	implicit none
	double precision p1, p2, p3, p4, p1p2, p2p3, m3

#include "lt.h"

	double precision m1_, m3_, m4_, d
	double complex xs, x2, x3, y, c, f
	double complex logxs, logx2, logx3, log1x2, log1x3, logy

	double complex ln, spence, bdK
	external ln, spence, bdK

	m1_ = sqrt(p1)
	m4_ = sqrt(p4)
	f = .5D0/(m1_*m4_*(p1p2 - m3))
	d = p2p3 - (m1_ - m4_)**2
	if( d .ne. 0 ) then
	  xs = bdK(p2p3, m1_, m4_)
	  logxs = log(xs)
	  f = f*2*xs/((1 - xs)*(1 + xs))
	endif

* massless case
	if( m3 .eq. 0 ) then
	  if( p1 .eq. p2 .and. p3 .eq. p4 ) then
	    D0ir = 2*f*ln(-lambda/p1p2, 1D0)
	    if( d .ne. 0 ) D0ir = -logxs*D0ir
	    return
	  endif
	  y = m1_/m4_*(p3 - p4 + cI*eps)/
     &                (p2 - p1 + cI*eps)
	  logy = log(y)
	  c = ln(lambda/m1_/m4_, 0D0) +
     &      ln((p2 - p1)/p1p2, p1 - p2) + ln((p3 - p4)/p1p2, p4 - p3)
	  if( d .ne. 0 ) then
	    D0ir = f*(pi6 - .5D0*(logxs - logy)*(logxs + logy) -
     &        spence(xs/y, 0D0) - (logxs + log(1/y))*log(1 - xs/y) -
     &        spence(xs*y, 0D0) - (logxs + logy)*log(1 - xs*y) +
     &        spence(xs**2, 0D0) +
     &        logxs*(2*log((1 - xs)*(1 + xs)) - c))
	    return
	  endif
	  D0ir = f*(c - 2 - (1 + y)/(1 - y)*logy)
	  return
	endif

* massive case
	m3_ = sqrt(m3)
	x2 = bdK(p2, m1_, m3_)
	x3 = bdK(p3, m4_, m3_)
	logx2 = log(x2)
	logx3 = log(x3)
	log1x3 = log(1/x3)
	c = ln(m3_*sqrt(lambda)/(m3 - p1p2), 1D0)
	if( d .ne. 0 ) then
	  log1x2 = log(1/x2)
	  D0ir = f*(.5D0*pi**2 +
     &      2*log(xs)*(log((1 - xs)*(1 + xs)) - c) +
     &      spence(xs**2, 0D0) + logx2**2 + logx3**2 -
     &      spence(xs/x2/x3, 0D0) -
     &      (logxs + log1x2 + log1x3)*log(1 - xs/x2/x3) -
     &      spence(xs*x2/x3, 0D0) -
     &      (logxs + logx2 + log1x3)*log(1 - xs*x2/x3) -
     &      spence(xs/x2*x3, 0D0) -
     &      (logxs + log1x2 + logx3)*log(1 - xs/x2*x3) -
     &      spence(xs*x2*x3, 0D0) -
     &      (logxs + logx2 + logx3)*log(1 - xs*x2*x3))
	  return
	endif
	D0ir = f*(2*c -
     &    (1 + x2/x3)/(1 - x2/x3)*(logx2 + log1x3) -
     &    (1 + x2*x3)/(1 - x2*x3)*(logx2 + logx3) - 2)
	end

************************************************************************

	double complex function D0m0(p1, p2, p3, p4, p1p2, p2p3,
     &                               m1, m2, m4)
	implicit none
	double precision p1, p2, p3, p4, p1p2, p2p3
	double precision m1, m2, m4

#include "lt.h"

	double complex D0m00, cspence, cln
	integer eta_tilde
	external D0m00, cspence, eta_tilde, cln

	double precision m1_, m2_, m4_
	double precision k12, k13, k14, k23, k24, k34
	double precision ir12, ir14, ir24, ix1(2), ix4(2)
	double complex r12, r14, r24, x4(2), x1
	double complex a, b, c, d, disc
	integer i

	if( m1 .eq. 0 ) then
	  D0m0 = D0m00(p1, p1p2, p3, p2p3, p2, p4, m2, m4)
	  return
	endif
	if( m2 .eq. 0 ) then
	  D0m0 = D0m00(p1, p2, p3, p4, p1p2, p2p3, m1, m4)
	  return
	endif
	if( m4 .eq. 0 ) then
	  D0m0 = D0m00(p4, p3, p2, p1, p1p2, p2p3, m1, m2)
	  return
	endif

	m1_ = sqrt(m1)
	m2_ = sqrt(m2)
	m4_ = sqrt(m4)

	k12 = (m1 + m2 - p1)/(m1_*m2_)
	k13 = (m1 - p1p2)/m1
	k14 = (m1 + m4 - p4)/(m1_*m4_)
	k23 = (m2 - p2)/(m2_*m1_)
	k24 = (m2 + m4 - p2p3)/(m2_*m4_)
	k34 = (m4 - p3)/(m1_*m4_)

	r12 = k2r(k12)
	r14 = k2r(k14)
	r24 = k2r(k24)

	a = k34/r24 - k23
	b = k13*(1/r24 - r24) + k12*k34 - k14*k23
	c = k13*(k12 - r24*k14) + r24*k34 - k23
	d = -k34*r24 + k23
	disc = sqrt(DCMPLX((k12*k34 - k13*k24 - k14*k23)**2 -
     &    4*(k13*(k13 - k23*(k12 - k14*k24)) +
     &       k23*(k23 - k24*k34) + k34*(k34 - k13*k14))))
	x4(1) = .5D0/a*(-b + disc)
	x4(2) = .5D0/a*(-b - disc)
	if( abs(x4(1)) .gt. abs(x4(2)) ) then
	  x4(2) = c/(a*x4(1))
	else
	  x4(1) = c/(a*x4(2))
	endif

	if( k12 .lt. -2 ) then
	  ir12 = sign(10D0, 1 - abs(r12))
	else
	  ir12 = 0
	endif
	if( k14 .lt. -2 ) then
	  ir14 = sign(10D0, 1 - abs(r14))
	else
	  ir14 = 0
	endif
	if( k24 .lt. -2 ) then
	  ir24 = sign(10D0, 1 - abs(r24))
	else
	  ir24 = 0
	endif

	ix4(2) = sign(1D0, DBLE(d))
	ix4(1) = -ix4(2)
	ix1(1) = sign(1D0, ix4(1)*DBLE(r24))
	ix1(2) = -ix1(1)

	b = DCMPLX(k34/k13)
	c = DCMPLX(k23/k13)

	D0m0 = 0
	do i = 1, 2
	  x1 = -x4(i)/r24
	  D0m0 = D0m0 + Sgn(i)*(
     &      cspence(-x4(i), r14, -ix4(i), ir14) +
     &      cspence(-x4(i), 1/r14, -ix4(i), -ir14) -
     &      cspence(x1, r12, -ix1(i), ir12) -
     &      cspence(x1, 1/r12, -ix1(i), -ir12) -
     &      cspence(-x4(i), b, -ix4(i), -k13) +
     &      cspence(x1, c, -ix1(i), -k13) -
     &      eta_tilde(-x4(i), 1/r24, -ix4(i), -ir24)*c2ipi*(
     &        cln((k12 - r24*(k14 + x4(i)) - x1)/d,
     &            DBLE(-(r24 - 1/r24)*ix4(i)/d)) +
     &        cln(DCMPLX(k13), -1D0) ) )
	enddo
	D0m0 = D0m0/(m1*m2_*m4_*a*(x4(1) - x4(2)))
	end

************************************************************************

	double complex function D0m00(p1, p2, p3, p4, p1p2, p2p3,
     &                                m1, m4)
	implicit none
	double precision p1, p2, p3, p4, p1p2, p2p3
	double precision m1, m4

#include "lt.h"

	double complex D0m000, cspence
	external D0m000, cspence

	double precision m1_, m4_
	double precision k12, k13, k14, k23, k24, k34
	double complex k12c, k13c, k23c, k24c, k34c
	double complex r14, x4(2)
	double complex a, b, c, disc
	integer i

	if( m1 .eq. 0 ) then
	  D0m00 = D0m000(p4, p1, p2, p3, p2p3, p1p2, m4)
	  return
	endif
	if( m4 .eq. 0 ) then
	  D0m00 = D0m000(p1, p2, p3, p4, p1p2, p2p3, m1)
	  return
	endif

	m1_ = sqrt(m1)
	m4_ = sqrt(m4)

	k12 = (m1 - p1)/m1
	k13 = (m1 - p1p2)/m1
	k14 = (m1 + m4 - p4)/(m1_*m4_)
	k23 = -p2/m1
	k24 = (m4 - p2p3)/(m1_*m4_)
	k34 = (m4 - p3)/(m1_*m4_)

	a = k34*k24 - k23
	b = k13*k24 + k12*k34 - k14*k23
	c = k13*k12 - k23*(1 - cI*eps)
	disc = sqrt(b**2 - 4*a*c)
	x4(1) = .5D0/a*(-b + disc)
	x4(2) = .5D0/a*(-b - disc)
	if( abs(x4(1)) .gt. abs(x4(2)) ) then
	  x4(2) = c/(a*x4(1))
	else
	  x4(1) = c/(a*x4(2))
	endif

	k12c = AddEps(k12)
	k13c = AddEps(k13)
	k23c = AddEps(k23)

	k24c = AddEps(k24)/k12c
	k34c = AddEps(k34)/k13c
	c = log(k12c) + log(k13c) - log(k23c)

	r14 = k2r(k14)
	r14 = r14*DCMPLX(1D0, sign(eps, DBLE(1/r14 - r14)))

	D0m00 = 0
	do i = 1, 2
	  D0m00 = D0m00 + Sgn(i)*(
     &      cspence(-x4(i), r14, 0D0, 0D0) +
     &      cspence(-x4(i), 1/r14, 0D0, 0D0) -
     &      cspence(-x4(i), k34c, 0D0, 0D0) -
     &      cspence(-x4(i), k24c, 0D0, 0D0) +
     &      log(-x4(i))*c )
	enddo
	D0m00 = D0m00/(m1*m1_*m4_*a*(x4(1) - x4(2)))
	end

************************************************************************

	double complex function D0m000(p1, p2, p3, p4, p1p2, p2p3, m1)
	implicit none
	double precision p1, p2, p3, p4, p1p2, p2p3
	double precision m1

#include "lt.h"

	double complex D0m0000, cspence
	external D0m0000, cspence

	double precision k12, k13, k14, k23, k24, k34
	double complex k12c, k13c, k14c, k23c, k24c, k34c
	double precision a, b
	double complex c, disc, x4(2)
	integer i

	if( m1 .eq. 0 ) then
	  D0m000 = D0m0000(p1, p2, p3, p4, p1p2, p2p3)
	  return
	endif

	k12 = (m1 - p1)/m1
	k13 = (m1 - p1p2)/m1
	k14 = (m1 - p4)/m1
	k23 = -p2/m1
	k24 = -p2p3/m1
	k34 = -p3/m1

	a = k34*k24
	b = k13*k24 + k12*k34 - k14*k23
	c = k13*k12 - k23*(1 - cI*eps)
	disc = sqrt(b*b - 4*a*c)
	x4(1) = .5D0/a*(-b + disc)
	x4(2) = .5D0/a*(-b - disc)
	if( abs(x4(1)) .gt. abs(x4(2)) ) then
	  x4(2) = c/(a*x4(1))
	else
	  x4(1) = c/(a*x4(2))
	endif

	k12c = AddEps(k12)
	k13c = AddEps(k13)
	k23c = AddEps(k23)
	k14c = AddEps(k14)

	k24c = AddEps(k24)/k12c
	k34c = AddEps(k34)/k13c
	c = log(k12c) + log(k13c) - log(k23c)

	D0m000 = 0
	do i = 1, 2
	  D0m000 = D0m000 + Sgn(i)*(
     &      cspence(-x4(i), k14c, 0D0, 0D0) -
     &      cspence(-x4(i), k34c, 0D0, 0D0) -
     &      cspence(-x4(i), k24c, 0D0, 0D0) +
     &      log(-x4(i))*c )
	enddo
	D0m000 = D0m000/(m1**2*a*(x4(1) - x4(2)))
	end

************************************************************************

	double complex function D0m0000(p1, p2, p3, p4, p1p2, p2p3)
	implicit none
	double precision p1, p2, p3, p4, p1p2, p2p3

#include "lt.h"

	double complex cspence
	external cspence

	double precision m2
	double precision k12, k13, k14, k23, k24, k34
	double complex k12c, k13c, k14c, k23c, k24c, k34c
	double precision a, b
	double complex c, disc, x4(2)
	integer i

	m2 = abs(p2p3)
	k12 = -p1/m2
	k13 = -p1p2/m2
	k14 = -p4/m2
	k23 = -p2/m2
	k24 = -p2p3/m2
	k34 = -p3/m2

	a = k34*k24
	b = k13*k24 + k12*k34 - k14*k23
	c = k13*k12 + cI*eps*k23
	disc = sqrt(b*b - 4*a*c)
	x4(1) = .5D0/a*(-b + disc)
	x4(2) = .5D0/a*(-b - disc)
	if( abs(x4(1)) .gt. abs(x4(2)) ) then
	  x4(2) = c/(a*x4(1))
	else
	  x4(1) = c/(a*x4(2))
	endif

	k12c = AddEps(k12)
	k13c = AddEps(k13)
	k23c = AddEps(k23)
	k14c = AddEps(k14)

	k24c = AddEps(k24)/k12c
	k34c = AddEps(k34)/k13c
	c = log(k12c) + log(k13c) - log(k23c) - log(k14c)

	D0m0000 = 0
	do i = 1, 2
	  disc = log(-x4(i))
	  D0m0000 = D0m0000 + Sgn(i)*(
     &      -cspence(-x4(i), k34c, 0D0, 0D0) -
     &      cspence(-x4(i), k24c, 0D0, 0D0) +
     &      disc*(c - .5D0*disc) )
	enddo
	D0m0000 = D0m0000/(m2**2*a*(x4(1) - x4(2)))
	end

************************************************************************

	double complex function D0reg(p1, p2, p3, p4, p1p2, p2p3,
     &                                m1, m2, m3, m4)
	implicit none
	double precision p1, p2, p3, p4, p1p2, p2p3
	double precision m1, m2, m3, m4

#include "lt.h"

	double complex cspence, cln
	integer eta, eta_tilde
	external cspence, cln, eta, eta_tilde

	double precision m1_, m2_, m3_, m4_
	double precision tmp, ir1324, gamma
	double precision kij(6), irij(6), ix(2,4)
	double complex rij(6), x(2,4)
	double complex a, b, c, d, disc, ki
	integer j, k

	double precision k12, k13, k14, k23, k24, k34
	double precision ir12, ir13, ir14, ir23, ir24, ir34
	double complex r12, r14, r13, r23, r24, r34
	equivalence (kij(1), k12), (rij(1), r12), (irij(1), ir12)
	equivalence (kij(2), k23), (rij(2), r23), (irij(2), ir23)
	equivalence (kij(3), k34), (rij(3), r34), (irij(3), ir34)
	equivalence (kij(4), k14), (rij(4), r14), (irij(4), ir14)
	equivalence (kij(5), k13), (rij(5), r13), (irij(5), ir13)
	equivalence (kij(6), k24), (rij(6), r24), (irij(6), ir24)

	m1_ = sqrt(m1)
	m2_ = sqrt(m2)
	m3_ = sqrt(m3)
	m4_ = sqrt(m4)

	k12 = (m1 + m2 - p1)/m1_/m2_
	k23 = (m2 + m3 - p2)/m2_/m3_
	k34 = (m3 + m4 - p3)/m3_/m4_
	k14 = (m1 + m4 - p4)/m1_/m4_
	k13 = (m1 + m3 - p1p2)/m1_/m3_
	k24 = (m2 + m4 - p2p3)/m2_/m4_

* test if r_13 can be made real by a permutation
* if one of the r_ij is real r_13 must be made real => case 1
	if( abs(k13) .ge. 2 ) then
*	  nothing to do
* otherwise try all permutations
	else if( abs(k12) .ge. 2 ) then
* 2 <-> 3
	  tmp = k12
	  k12 = k13
	  k13 = tmp
	  tmp = k24
	  k24 = k34
	  k34 = tmp
	else if( abs(k14) .ge. 2 ) then
* 3 <-> 4
	  tmp = k13
	  k13 = k14
	  k14 = tmp
	  tmp = k23
	  k23 = k24
	  k24 = tmp
	else if( abs(k23) .ge. 2 ) then
* 1 <-> 2
	  tmp = k13
	  k13 = k23
	  k23 = tmp
	  tmp = k14
	  k14 = k24
	  k24 = tmp
	else if( abs(k24) .ge. 2 ) then
*  1 -> 4, 2 -> 1, 3 -> 2, 4 -> 3
	  tmp = k12
	  k12 = k23
          k23 = k34
	  k34 = k14
	  k14 = tmp
	  tmp = k13
	  k13 = k24
	  k24 = tmp
	else if( abs(k34) .ge. 2 ) then
* 1 <-> 4
	  tmp = k12
	  k12 = k24
	  k24 = tmp
	  tmp = k13
	  k13 = k34
	  k34 = tmp
* 	else
* nothing found => all r_ij on the complex unit circle => case 2
	endif

	r12 = k2r(k12)
	r23 = k2r(k23)
	r34 = k2r(k34)
	r14 = k2r(k14)
	r13 = 1/k2r(k13)
	r24 = 1/k2r(k24)

	do j = 1, 6
	  if( DIMAG(rij(j)) .eq. 0 ) then
	    ki = kij(j) - cI*eps
	    irij(j) = sign(1D0, abs(rij(j)) - 1)*
     &        DIMAG(k2r(ki))
	  else
	    irij(j) = 0
	  endif
	enddo

	ir1324 = sign(1D0, DBLE(r24))*ir13 -
     &           sign(1D0, DBLE(r13))*ir24

	a = k34/r24 - k23 + (k12 - k14/r24)*r13
	b = (1/r13 - r13)*(1/r24 - r24) + k12*k34 - k14*k23
	c = k34*r24 - k23 + (k12 - k14*r24)/r13
	d = k23 + (r24*k14 - k12)*r13 - r24*k34
	disc = sqrt(b**2 - 4*a*(c + cI*eps*d))
	ix(1,4) = DIMAG(.5D0/a*(-b + disc))
	ix(2,4) = DIMAG(.5D0/a*(-b - disc))

	disc = sqrt(b**2 - 4*a*c)
	x(1,4) = .5D0/a*(-b + disc)
	x(2,4) = .5D0/a*(-b - disc)
	if( abs(x(1,4)) .gt. abs(x(2,4)) ) then
	  x(2,4) = c/a/x(1,4)
	else    
	  x(1,4) = c/a/x(2,4)
	endif

	x(1,1) = x(1,4)/r24
	x(2,1) = x(2,4)/r24
	x(1,2) = x(1,4)/r24*r13
	x(2,2) = x(2,4)/r24*r13
	x(1,3) = x(1,4)*r13
	x(2,3) = x(2,4)*r13

	ix(1,1) = ix(1,4)*DBLE(x(1,1))*sign(1D0, DBLE(x(1,4)))
	ix(2,1) = ix(2,4)*DBLE(x(2,1))*sign(1D0, DBLE(x(2,4)))
	ix(1,2) = ix(1,4)*DBLE(x(1,2))*sign(1D0, DBLE(x(1,4)))
	ix(2,2) = ix(2,4)*DBLE(x(2,2))*sign(1D0, DBLE(x(2,4)))
	ix(1,3) = ix(1,4)*DBLE(x(1,3))*sign(1D0, DBLE(x(1,4)))
	ix(2,3) = ix(2,4)*DBLE(x(2,3))*sign(1D0, DBLE(x(2,4)))
 
	D0reg = 0
	do k = 1, 2
	  do j = 1, 4
	    D0reg = D0reg + Sgn(j + k)*(
     &        cspence(-x(k,j), rij(j), -ix(k,j), irij(j)) +
     &        cspence(-x(k,j), 1/rij(j), -ix(k,j), -irij(j)) )
	  enddo
	  gamma = sign(1D0, DBLE(a*(x(k,4) - x(3-k,4))))
	  if( DIMAG(r13) .eq. 0 ) then
	    D0reg = D0reg - Sgn(k)*c2ipi*(
     &        eta_tilde(-x(k,4), r13, -ix(k,4), ir13)*(
     &          cln(x(k,3), ix(k,3)) + 
     &          cln((k13 - 2*r13)/x(k,4) - r13*k14 + k34, -1D0) +
     &          cln(((k24 - 2*r24)*x(k,3) - r24*k34 + k23)/d,
     &            gamma*sign(1D0, DBLE(r13)*(DIMAG(r24) + ir24)))
     &        ) + 
     &        eta_tilde(-x(k,4), 1/r24, -ix(k,4), -ir24)*(
     &          cln(x(k,1), ix(k,1)) + 
     &          cln((k13 - 2*r13)/x(k,1) - r13*k12 + k23, -1D0) +
     &          cln(((k24 - 2*r24)*x(k,4) - r24*k14 + k12)/d,
     &            gamma*sign(1D0, DIMAG(r24) + ir24))
     &        ) - 
     &        (eta_tilde(-x(k,4), r13/r24, -ix(k,4), ir1324) +
     &          eta(r13, 1/r24, ir13, -ir24, ir1324))*(
     &          cln(x(k,2), ix(k,2)) + 
     &          cln((k13 - 2*r13)/x(k,1) - r13*k12 + k23, -1D0) +
     &          cln(((k24 - 2*r24)*x(k,3) - r24*k34 + k23)/d,
     &            gamma*sign(1D0, DBLE(r13)*(DIMAG(r24) + ir24)))
     &        ) + 
     &        eta_tilde(-x(k,4), -r13/r24, -ix(k,4), -ir1324)*
     &          eta(r13, 1D0/r24, ir13, -ir24, ir1324)*c2ipi
     &      )
	  else
	    D0reg = D0reg - Sgn(k)*c2ipi*(
     &        eta(-x(k,4), 1/r24, -ix(k,4), -ir24, -ix(k,1))*(
     &          cln(1/x(k,1) + x(k,1) + k12, x(k,1)*b*gamma) +
     &          log(x(k,1))
     &        ) +
     &        eta(-x(k,4), r13, -ix(k,4), ir13, -ix(k,3))*(
     &          cln(1/x(k,3) + x(k,3) + k34, x(k,3)*b*gamma) +
     &          log(x(k,3))
     &        ) -
     &        (eta(-x(k,4), r13/r24, -ix(k,4), ir13/ir24, -ix(k,2)) +
     &          eta(r13, 1D0/r24, ir13, -ir24, ir13/ir24))*(
     &          cln(1/x(k,2) + x(k,2) + k23, x(k,2)*b*gamma) +
     &          log(x(k,2))
     &        ) +
     &        eta(-x(k,4), -r13/r24, -ix(k,4), -ir13/ir24, ix(k,2))*
     &          eta(r13, 1/r24, ir13, -ir24, ir13/ir24)*
     &          (1 - sign(1D0, DBLE(b))*gamma)*c2ipi
     &      )
	  endif
	enddo
	D0reg = D0reg/m1_/m2_/m3_/m4_/disc
	end

************************************************************************

	double complex function bdK(x, m1, m2)
* this is actually -K from the Beenakker/Denner paper for D0ir
	implicit none
	double precision x, m1, m2

#include "lt.h"

	double precision d
	double complex t

	d = x - (m1 - m2)**2
	if( d .eq. 0 ) then
	  bdK = 1
	else
	  t = 4*m1*m2/(d + cI*eps)
	  bdK = -t/(sqrt(1 - t) + 1)**2
	endif
	end

************************************************************************

	double complex function cspence(z1, z2, im1, im2)
	implicit none
	double complex z1, z2
	double precision im1, im2

#include "lt.h"

	double complex cln, spence
	integer eta
	external cln, spence, eta

	double complex z12
	double precision im12
	integer etas

	z12 = z1*z2
	im12 = im2*sign(1D0, DBLE(z1))
	if( DBLE(z12) .gt. .5D0 ) then
	  cspence = spence(1 - z12, 0D0)
	  etas = eta(z1, z2, im1, im2, im12)
	  if( etas .ne. 0 ) cspence = cspence +
     &      etas*cln(1 - z12, -im12)*c2ipi
	else if( abs(z12) .lt. 1D-4 ) then
	  cspence = pi6
	  if( abs(z12) .gt. 1D-14 ) cspence = cspence -
     &      spence(z12, 0D0) +
     &      (cln(z1, im1) + cln(z2, im2))*z12*
     &        (1 + z12*(.5D0 + z12*(1/3D0 + z12/4D0)))
	else
	  cspence = pi6 -
     &      spence(z12, 0D0) -
     &      (cln(z1, im1) + cln(z2, im2))*cln(1 - z12, 0D0)
	endif
	end

************************************************************************

	integer function eta_tilde(c1, c2, im1x, im2x)
	implicit none
	double complex c1, c2
	double precision im1x, im2x

	double precision im1, im2

	integer eta
	external eta

	im1 = DIMAG(c1)
	if( im1 .eq. 0 ) im1 = im1x
	im2 = DIMAG(c2)
	if( im2 .ne. 0 ) then
	  eta_tilde = eta(c1, c2, im1x, 0D0, 0D0)
	else if( DBLE(c2) .gt. 0 ) then
	  eta_tilde = 0
	else if( im1 .gt. 0 .and. im2x .gt. 0 ) then
	  eta_tilde = -1
	else if( im1 .lt. 0 .and. im2x .lt. 0 ) then
	  eta_tilde = 1
	else
	  eta_tilde = 0
#ifdef WARNINGS
	  if( im1 .eq. 0 .and. DBLE(c1) .lt. 0 .or.
     &        im2x .eq. 0 .and. DBLE(c1*c2) .lt. 0 )
     &      print *, "eta_tilde not defined"
#endif
	endif
	end

