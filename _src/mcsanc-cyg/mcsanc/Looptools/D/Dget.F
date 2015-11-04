* Dget.F
* retrieve the four-point tensor coefficients
* this file is part of LoopTools
* improvements by M. Rauch
* last modified 7 Dec 05 th

#include "defs.h"


	integer function XDget(p1, p2, p3, p4, p1p2, p2p3,
     &    m1, m2, m3, m4)
	implicit none
	DVAR p1, p2, p3, p4, p1p2, p2p3
	DVAR m1, m2, m3, m4

#include "lt.h"

	integer cachelookup
	external cachelookup, XDcoeff

	DVAR para(Pdd)

	para(1) = p1
	para(2) = p2
	para(3) = p3
	para(4) = p4
	para(5) = p1p2
	para(6) = p2p3
	para(7) = m1
	para(8) = m2
	para(9) = m3
	para(10) = m4

	XDget = cachelookup(para, Dval(1,0), XDcoeff, RC*Pdd, Ndd)
	end

************************************************************************

	double complex function XD0i(i, p1, p2, p3, p4, p1p2, p2p3,
     &    m1, m2, m3, m4)
	implicit none
	integer i
	DVAR p1, p2, p3, p4, p1p2, p2p3
	DVAR m1, m2, m3, m4

#include "lt.h"

	integer XDget
	external XDget

	integer b

	b = XDget(p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4)
	XD0i = Dval(i,b)
	end

************************************************************************

	subroutine XDcoeff(para, D, ldpara)
	implicit none
	integer ldpara
	DVAR para(ldpara,Pdd)
	double complex D(Ndd)

#include "lt.h"

	integer XCget
	double complex XD0
	external XCget, XD0

	DVAR p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4
	DVAR f1, f2, f3
	QVAR G(3,3)
	double complex c0sum, c1sum, c2sum, csum
	double complex c00sum, c11sum, c12sum, c22sum
	double complex in(3)
	integer C234, C134, C124, C123
	integer perm(3)
	logical dump

	p1 = para(1,1)
	p2 = para(1,2)
	p3 = para(1,3)
	p4 = para(1,4)
	p1p2 = para(1,5)
	p2p3 = para(1,6)
	m1 = para(1,7)
	m2 = para(1,8)
	m3 = para(1,9)
	m4 = para(1,10)

#ifdef COMPLEXPARA
	if( DIMAG(p1) .eq. 0 .and.
     &      DIMAG(p2) .eq. 0 .and.
     &      DIMAG(p3) .eq. 0 .and.
     &      DIMAG(p4) .eq. 0 .and.
     &      DIMAG(p1p2) .eq. 0 .and.
     &      DIMAG(p2p3) .eq. 0 .and.
     &      DIMAG(m1) .eq. 0 .and.
     &      DIMAG(m2) .eq. 0 .and.
     &      DIMAG(m3) .eq. 0 .and.
     &      DIMAG(m4) .eq. 0 ) then
	  call Dcoeff(para, D, 2)
	  return
	endif
#endif

	C234 = XCget(p2, p3, p2p3, m2, m3, m4)
	C134 = XCget(p1p2, p3, p4, m1, m3, m4)
	C124 = XCget(p1, p2p3, p4, m1, m2, m4)
	C123 = XCget(p1, p2, p1p2, m1, m2, m3)

	serial = serial + 1
	dump = ibits(debugkey, DebugD, 1) .ne. 0 .and.
     &    serial .ge. debugfrom .and. serial .le. debugto
	if( dump ) call XDumpPara(4, para, ldpara, "Dcoeff")

	f1 = QEXT(m2) - QEXT(m1) - QEXT(p1)
	f2 = QEXT(m3) - QEXT(m1) - QEXT(p1p2)
	f3 = QEXT(m4) - QEXT(m1) - QEXT(p4)

	G(1,1) = 2*QEXT(p1)
	G(2,2) = 2*QEXT(p1p2)
	G(3,3) = 2*QEXT(p4)
	G(1,2) = QEXT(p1) + QEXT(p1p2) - QEXT(p2)
	G(2,1) = G(1,2)
	G(1,3) = QEXT(p1) + QEXT(p4) - QEXT(p2p3)
	G(3,1) = G(1,3)
	G(2,3) = QEXT(p1p2) - QEXT(p3) + QEXT(p4)
	G(3,2) = G(2,3)
	call XLUDecomp(G, 3, perm)

	c0sum = Cval(cc0,C234) + Cval(cc1,C234) + Cval(cc2,C234)
	c1sum = Cval(cc1,C234) + Cval(cc11,C234) + Cval(cc12,C234)
	c2sum = Cval(cc2,C234) + Cval(cc12,C234) + Cval(cc22,C234)
	csum = c0sum + c1sum + c2sum

	c00sum = Cval(cc00,C234) +
     &    Cval(cc001,C234) + Cval(cc002,C234)
	c11sum = Cval(cc11,C234) +
     &    Cval(cc111,C234) + Cval(cc112,C234)
	c12sum = Cval(cc12,C234) +
     &    Cval(cc112,C234) + Cval(cc122,C234)
	c22sum = Cval(cc22,C234) +
     &    Cval(cc122,C234) + Cval(cc222,C234)

	D(dd0) = XD0(p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4)

	in(1) = f1*D(dd0) - Cval(cc0,C234) + Cval(cc0,C134)
	in(2) = f2*D(dd0) - Cval(cc0,C234) + Cval(cc0,C124)
	in(3) = f3*D(dd0) - Cval(cc0,C234) + Cval(cc0,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd1) = in(1)
	D(dd2) = in(2)
	D(dd3) = in(3)

	D(dd00) = m1*D(dd0) - .5D0*
     &    (D(dd1)*f1 + D(dd2)*f2 + D(dd3)*f3 - Cval(cc0,C234))

	in(1) = f1*D(dd1) + c0sum - 2*D(dd00)
	in(2) = f2*D(dd1) + c0sum + Cval(cc1,C124)
	in(3) = f3*D(dd1) + c0sum + Cval(cc1,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd11) = in(1)
	D(dd12) = in(2)
	D(dd13) = in(3)

	in(1) = f1*D(dd2) - Cval(cc1,C234) + Cval(cc1,C134)
	in(2) = f2*D(dd2) - Cval(cc1,C234) - 2*D(dd00)
	in(3) = f3*D(dd2) - Cval(cc1,C234) + Cval(cc2,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd12) = .5D0*(D(dd12) + in(1))
	D(dd22) = in(2)
	D(dd23) = in(3)

	in(1) = f1*D(dd3) - Cval(cc2,C234) + Cval(cc2,C134)
	in(2) = f2*D(dd3) - Cval(cc2,C234) + Cval(cc2,C124)
	in(3) = f3*D(dd3) - Cval(cc2,C234) - 2*D(dd00)
	call XLUBackSubst(G, 3, perm, in)
	D(dd13) = .5D0*(D(dd13) + in(1))
	D(dd23) = .5D0*(D(dd23) + in(2))
	D(dd33) = in(3)

	in(1) = f1*D(dd00) - Cval(cc00,C234) + Cval(cc00,C134)
	in(2) = f2*D(dd00) - Cval(cc00,C234) + Cval(cc00,C124)
	in(3) = f3*D(dd00) - Cval(cc00,C234) + Cval(cc00,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd001) = in(1)
	D(dd002) = in(2)
	D(dd003) = in(3)

	in(1) = f1*D(dd11) - csum - 4*D(dd001)
	in(2) = f2*D(dd11) - csum + Cval(cc11,C124)
	in(3) = f3*D(dd11) - csum + Cval(cc11,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd111) = in(1)
	D(dd112) = in(2)
	D(dd113) = in(3)

	in(1) = f1*D(dd22) - Cval(cc11,C234) + Cval(cc11,C134)
	in(2) = f2*D(dd22) - Cval(cc11,C234) - 4*D(dd002)
	in(3) = f3*D(dd22) - Cval(cc11,C234) + Cval(cc22,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd122) = in(1)
	D(dd222) = in(2)
	D(dd223) = in(3)

	in(1) = f1*D(dd33) - Cval(cc22,C234) + Cval(cc22,C134)
	in(2) = f2*D(dd33) - Cval(cc22,C234) + Cval(cc22,C124)
	in(3) = f3*D(dd33) - Cval(cc22,C234) - 4*D(dd003)
	call XLUBackSubst(G, 3, perm, in)
	D(dd133) = in(1)
	D(dd233) = in(2)
	D(dd333) = in(3)

	in(1) = f1*D(dd13) + c2sum - 2*D(dd003)
	in(2) = f2*D(dd13) + c2sum + Cval(cc12,C124)
	in(3) = f3*D(dd13) + c2sum - 2*D(dd001)
	call XLUBackSubst(G, 3, perm, in)
	D(dd113) = .5D0*(D(dd113) + in(1))
	D(dd123) = in(2)
	D(dd133) = .5D0*(D(dd133) + in(3))

	D(dd0000) = 1/3D0*(m1*D(dd00) -
     &    .5D0*(f1*D(dd001) + f2*D(dd002) + f3*D(dd003) -
     &      Cval(cc00,C234) - 1/6D0))
	D(dd0011) = 1/3D0*(m1*D(dd11) -
     &    .5D0*(f1*D(dd111) + f2*D(dd112) + f3*D(dd113) - csum))
	D(dd0012) = 1/3D0*(m1*D(dd12) -
     &    .5D0*(f1*D(dd112) + f2*D(dd122) + f3*D(dd123) + c1sum))
	D(dd0013) = 1/3D0*(m1*D(dd13) -
     &    .5D0*(f1*D(dd113) + f2*D(dd123) + f3*D(dd133) + c2sum))
	D(dd0022) = 1/3D0*(m1*D(dd22) -
     &    .5D0*(f1*D(dd122) + f2*D(dd222) + f3*D(dd223) -
     &      Cval(cc11,C234)))
	D(dd0023) = 1/3D0*(m1*D(dd23) -
     &    .5D0*(f1*D(dd123) + f2*D(dd223) + f3*D(dd233) -
     &      Cval(cc12,C234)))
	D(dd0033) = 1/3D0*(m1*D(dd33) -
     &    .5D0*(f1*D(dd133) + f2*D(dd233) + f3*D(dd333) -
     &      Cval(cc22,C234)))

	c1sum = c1sum + c11sum + c12sum
	c2sum = c2sum + c12sum + c22sum
	csum = csum + c1sum + c2sum

	in(1) = f1*D(dd111) + csum - 6*D(dd0011)
	in(2) = f2*D(dd111) + csum + Cval(cc111,C124)
	in(3) = f3*D(dd111) + csum + Cval(cc111,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd1111) = in(1)
	D(dd1112) = in(2)
	D(dd1113) = in(3)

	in(1) = f1*D(dd113) - c2sum - 4*D(dd0013)
	in(2) = f2*D(dd113) - c2sum + Cval(cc112,C124)
	in(3) = f3*D(dd113) - c2sum - 2*D(dd0011)
	call XLUBackSubst(G, 3, perm, in)
	D(dd1113) = .5D0*(D(dd1113) + in(1))
	D(dd1123) = in(2)
	D(dd1133) = in(3)

	in(1) = f1*D(dd122) + c11sum - 2*D(dd0022)
	in(2) = f2*D(dd122) + c11sum - 4*D(dd0012)
	in(3) = f3*D(dd122) + c11sum + Cval(cc122,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd1122) = in(1)
	D(dd1222) = in(2)
	D(dd1223) = in(3)

	in(1) = f1*D(dd222) - Cval(cc111,C234) + Cval(cc111,C134)
	in(2) = f2*D(dd222) - Cval(cc111,C234) - 6*D(dd0022)
	in(3) = f3*D(dd222) - Cval(cc111,C234) + Cval(cc222,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd1222) = .5D0*(D(dd1222) + in(1))
	D(dd2222) = in(2)
	D(dd2223) = in(3)

	in(1) = f1*D(dd233) - Cval(cc122,C234) + Cval(cc122,C134)
	in(2) = f2*D(dd233) - Cval(cc122,C234) - 2*D(dd0033)
	in(3) = f3*D(dd233) - Cval(cc122,C234) - 4*D(dd0023)
	call XLUBackSubst(G, 3, perm, in)
	D(dd1233) = in(1)
	D(dd2233) = in(2)
	D(dd2333) = in(3)

	in(1) = f1*D(dd333) - Cval(cc222,C234) + Cval(cc222,C134)
	in(2) = f2*D(dd333) - Cval(cc222,C234) + Cval(cc222,C124)
	in(3) = f3*D(dd333) - Cval(cc222,C234) - 6*D(dd0033)
	call XLUBackSubst(G, 3, perm, in)
	D(dd1333) = in(1)
	D(dd2333) = .5D0*(D(dd2333) + in(2))
	D(dd3333) = in(3)

	c00sum = c00sum +
     &    Cval(cc001,C234) + Cval(cc0011,C234) + Cval(cc0012,C234) +
     &    Cval(cc002,C234) + Cval(cc0012,C234) + Cval(cc0022,C234)
	c11sum = c11sum +
     &    Cval(cc111,C234) + Cval(cc1111,C234) + Cval(cc1112,C234) +
     &    Cval(cc112,C234) + Cval(cc1112,C234) + Cval(cc1122,C234)
	c12sum = c12sum +
     &    Cval(cc112,C234) + Cval(cc1112,C234) + Cval(cc1122,C234) +
     &    Cval(cc122,C234) + Cval(cc1122,C234) + Cval(cc1222,C234)
	c22sum = c22sum +
     &    Cval(cc122,C234) + Cval(cc1122,C234) + Cval(cc1222,C234) +
     &    Cval(cc222,C234) + Cval(cc1222,C234) + Cval(cc2222,C234)
	c1sum = c1sum + c11sum + c12sum
	c2sum = c2sum + c12sum + c22sum
	csum = csum + c1sum + c2sum

	in(1) = f1*D(dd0000) - Cval(cc0000,C234) + Cval(cc0000,C134)
	in(2) = f2*D(dd0000) - Cval(cc0000,C234) + Cval(cc0000,C124)
	in(3) = f3*D(dd0000) - Cval(cc0000,C234) + Cval(cc0000,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd00001) = in(1)
	D(dd00002) = in(2)
	D(dd00003) = in(3)

	in(1) = f1*D(dd0011) - c00sum - 4*D(dd00001)
	in(2) = f2*D(dd0011) - c00sum + Cval(cc0011,C124)
	in(3) = f3*D(dd0011) - c00sum + Cval(cc0011,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd00111) = in(1)
	D(dd00112) = in(2)
	D(dd00113) = in(3)

	in(1) = f1*D(dd0022) - Cval(cc0011,C234) + Cval(cc0011,C134)
	in(2) = f2*D(dd0022) - Cval(cc0011,C234) - 4*D(dd00002)
	in(3) = f3*D(dd0022) - Cval(cc0011,C234) + Cval(cc0022,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd00122) = in(1)
	D(dd00222) = in(2)
	D(dd00223) = in(3)

	in(1) = f1*D(dd0033) - Cval(cc0022,C234) + Cval(cc0022,C134)
	in(2) = f2*D(dd0033) - Cval(cc0022,C234) + Cval(cc0022,C124)
	in(3) = f3*D(dd0033) - Cval(cc0022,C234) - 4*D(dd00003)
	call XLUBackSubst(G, 3, perm, in)
	D(dd00133) = in(1)
	D(dd00233) = in(2)
	D(dd00333) = in(3)

	in(1) = f1*D(dd0023) - Cval(cc0012,C234) + Cval(cc0012,C134)
	in(2) = f2*D(dd0023) - Cval(cc0012,C234) - 2*D(dd00003)
	in(3) = f3*D(dd0023) - Cval(cc0012,C234) - 2*D(dd00002)
	call XLUBackSubst(G, 3, perm, in)
	D(dd00123) = in(1)
	D(dd00223) = .5D0*(D(dd00223) + in(2))
	D(dd00233) = .5D0*(D(dd00233) + in(3))

	in(1) = f1*D(dd1111) - csum - 8*D(dd00111)
	in(2) = f2*D(dd1111) - csum + Cval(cc1111,C124)
	in(3) = f3*D(dd1111) - csum + Cval(cc1111,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd11111) = in(1)
	D(dd11112) = in(2)
	D(dd11113) = in(3)

	in(1) = f1*D(dd2222) - Cval(cc1111,C234) + Cval(cc1111,C134)
	in(2) = f2*D(dd2222) - Cval(cc1111,C234) - 8*D(dd00222)
	in(3) = f3*D(dd2222) - Cval(cc1111,C234) + Cval(cc2222,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd12222) = in(1)
	D(dd22222) = in(2)
	D(dd22223) = in(3)

	in(1) = f1*D(dd3333) - Cval(cc2222,C234) + Cval(cc2222,C134)
	in(2) = f2*D(dd3333) - Cval(cc2222,C234) + Cval(cc2222,C124)
	in(3) = f3*D(dd3333) - Cval(cc2222,C234) - 8*D(dd00333)
	call XLUBackSubst(G, 3, perm, in)
	D(dd13333) = in(1)
	D(dd23333) = in(2)
	D(dd33333) = in(3)

	in(1) = f1*D(dd1122) - c11sum - 4*D(dd00122)
	in(2) = f2*D(dd1122) - c11sum - 4*D(dd00112)
	in(3) = f3*D(dd1122) - c11sum + Cval(cc1122,C123)
	call XLUBackSubst(G, 3, perm, in)
	D(dd11122) = in(1)
	D(dd11222) = in(2)
	D(dd11223) = in(3)

	in(1) = f1*D(dd1133) - c22sum - 4*D(dd00133)
	in(2) = f2*D(dd1133) - c22sum + Cval(cc1122,C124)
	in(3) = f3*D(dd1133) - c22sum - 4*D(dd00113)
	call XLUBackSubst(G, 3, perm, in)
	D(dd11133) = in(1)
	D(dd11233) = in(2)
	D(dd11333) = in(3)

	in(1) = f1*D(dd2233) - Cval(cc1122,C234) + Cval(cc1122,C134)
	in(2) = f2*D(dd2233) - Cval(cc1122,C234) - 4*D(dd00233)
	in(3) = f3*D(dd2233) - Cval(cc1122,C234) - 4*D(dd00223)
	call XLUBackSubst(G, 3, perm, in)
	D(dd12233) = in(1)
	D(dd22233) = in(2)
	D(dd22333) = in(3)

	in(1) = f1*D(dd1123) - c12sum - 4*D(dd00123)
	in(2) = f2*D(dd1123) - c12sum - 2*D(dd00113)
	in(3) = f3*D(dd1123) - c12sum - 2*D(dd00112)
	call XLUBackSubst(G, 3, perm, in)
	D(dd11123) = in(1)
	D(dd11223) = .5D0*(D(dd11223) + in(2))
	D(dd11233) = .5D0*(D(dd11233) + in(3))

	in(1) = f1*D(dd2223) - Cval(cc1112,C234) + Cval(cc1112,C134)
	in(2) = f2*D(dd2223) - Cval(cc1112,C234) - 6*D(dd00223)
	in(3) = f3*D(dd2223) - Cval(cc1112,C234) - 2*D(dd00222)
	call XLUBackSubst(G, 3, perm, in)
	D(dd12223) = in(1)
	D(dd22223) = .5D0*(D(dd22223) + in(2))
	D(dd22233) = .5D0*(D(dd22233) + in(3))

	in(1) = f1*D(dd2333) - Cval(cc1222,C234) + Cval(cc1222,C134)
	in(2) = f2*D(dd2333) - Cval(cc1222,C234) - 2*D(dd00333)
	in(3) = f3*D(dd2333) - Cval(cc1222,C234) - 6*D(dd00233)
	call XLUBackSubst(G, 3, perm, in)
	D(dd12333) = in(1)
	D(dd22333) = .5D0*(D(dd22333) + in(2))
	D(dd23333) = .5D0*(D(dd23333) + in(3))

	if( dump ) call XDumpCoeff(4, D)
	end

