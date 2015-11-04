* Ecoeffb.F
* the five-point tensor coefficients via Passarino-Veltman decomposition
* this file is part of LoopTools
* written by M. Rauch
* last modified 7 Dec 05 th

#include "defs.h"


	subroutine XEcoeffb(para, E, ldpara)
	implicit none
	integer ldpara
	DVAR para(ldpara,Pee)
	double complex E(Nee)

#include "lt.h"

	integer XDget
	double complex XE0
	external XDget, XE0

	DVAR p1, p2, p3, p4, p5
	DVAR p1p2, p2p3, p3p4, p4p5, p5p1
	DVAR m1, m2, m3, m4, m5

	DVAR f1, f2, f3, f4
	double complex di, d0sum
	double complex d1i, d1sum, d2i, d2sum, dii
	double complex d1ii, d2ii, diii
	double complex d00sum, d22sum, d33sum
	double complex in(4)
	integer Di1, Di2, Di3, Di4, Di5
	integer perm(4)
	logical dump

	QVAR G(4,4), Y(4,4)
	common /XltEgram/ Y

	p1 = para(1,1)
	p2 = para(1,2)
	p3 = para(1,3)
	p4 = para(1,4)
	p5 = para(1,5)
	p1p2 = para(1,6)
	p2p3 = para(1,7)
	p3p4 = para(1,8)
	p4p5 = para(1,9)
	p5p1 = para(1,10)
	m1 = para(1,11)
	m2 = para(1,12)
	m3 = para(1,13)
	m4 = para(1,14)
	m5 = para(1,15)

#ifdef COMPLEXPARA
	if( DIMAG(p1) .eq. 0 .and.
     &      DIMAG(p2) .eq. 0 .and.
     &      DIMAG(p3) .eq. 0 .and.
     &      DIMAG(p4) .eq. 0 .and.
     &      DIMAG(p5) .eq. 0 .and.
     &      DIMAG(p1p2) .eq. 0 .and.
     &      DIMAG(p2p3) .eq. 0 .and.
     &      DIMAG(p3p4) .eq. 0 .and.
     &      DIMAG(p4p5) .eq. 0 .and.
     &      DIMAG(p5p1) .eq. 0 .and.
     &      DIMAG(m1) .eq. 0 .and.
     &      DIMAG(m2) .eq. 0 .and.
     &      DIMAG(m3) .eq. 0 .and.
     &      DIMAG(m4) .eq. 0 .and.
     &      DIMAG(m5) .eq. 0 ) then
	  call Ecoeffb(para, E, 2)
	  return
	endif
#endif

	Di1 = XDget(p2, p3, p4, p5p1, p2p3, p3p4, m2, m3, m4, m5)
	Di2 = XDget(p1p2, p3, p4, p5, p4p5, p3p4, m1, m3, m4, m5)
	Di3 = XDget(p1, p2p3, p4, p5, p4p5, p5p1, m1, m2, m4, m5)
	Di4 = XDget(p1, p2, p3p4, p5, p1p2, p5p1, m1, m2, m3, m5)
	Di5 = XDget(p1, p2, p3, p4p5, p1p2, p2p3, m1, m2, m3, m4)

	serial = serial + 1
	dump = ibits(debugkey, DebugE, 1) .ne. 0 .and.
     &    serial .ge. debugfrom .and. serial .le. debugto
	if( dump ) call XDumpPara(5, para, ldpara)

	f1 = QEXT(m2) - QEXT(m1) - QEXT(p1)
	f2 = QEXT(m3) - QEXT(m1) - QEXT(p1p2)
	f3 = QEXT(m4) - QEXT(m1) - QEXT(p4p5)
	f4 = QEXT(m5) - QEXT(m1) - QEXT(p5)

* build up G and calculate its LU-decomposition and its inverse Y
	G(1,1) = 2*QEXT(p1)
	G(2,2) = 2*QEXT(p1p2)
	G(3,3) = 2*QEXT(p4p5)
	G(4,4) = 2*QEXT(p5)
	G(1,2) = QEXT(p1) + QEXT(p1p2) - QEXT(p2)
	G(2,1) = G(1,2)
	G(1,3) = QEXT(p1) - QEXT(p2p3) + QEXT(p4p5)
	G(3,1) = G(1,3)
	G(1,4) = QEXT(p1) - QEXT(p5p1) + QEXT(p5)
	G(4,1) = G(1,4)
	G(2,3) = QEXT(p1p2) - QEXT(p3) + QEXT(p4p5)
	G(3,2) = G(2,3)
	G(2,4) = QEXT(p1p2) - QEXT(p3p4) + QEXT(p5)
	G(4,2) = G(2,4)
	G(3,4) = QEXT(p5) + QEXT(p4p5) - QEXT(p4)
	G(4,3) = G(3,4)
	call XInverse(G, Y, 4, perm)

	di = Dval(dd1,Di1) + Dval(dd2,Di1) + Dval(dd3,Di1)
	d0sum = Dval(dd0,Di1) + di

	d1i = Dval(dd11,Di1) + Dval(dd12,Di1) + Dval(dd13,Di1)
	d1sum = Dval(dd1,Di1) + d1i
	d2i = Dval(dd12,Di1) + Dval(dd22,Di1) + Dval(dd23,Di1)
	d2sum = Dval(dd2,Di1) + d2i
	dii = d1i + d2i +
     &    Dval(dd13,Di1) + Dval(dd23,Di1) + Dval(dd33,Di1)

	d1ii = Dval(dd111,Di1) + Dval(dd122,Di1) +
     &    Dval(dd133,Di1) + 2*(Dval(dd112,Di1) +
     &    Dval(dd113,Di1) + Dval(dd123,Di1))
	d2ii = Dval(dd112,Di1) + Dval(dd222,Di1) +
     &    Dval(dd233,Di1) + 2*(Dval(dd122,Di1) +
     &    Dval(dd123,Di1) + Dval(dd223,Di1))
	diii = d1ii + d2ii +
     &    Dval(dd113,Di1) + Dval(dd223,Di1) +
     &    Dval(dd333,Di1) + 2*(Dval(dd123,Di1) +
     &    Dval(dd133,Di1) + Dval(dd233,Di1))

	d00sum = Dval(dd00,Di1) +
     &    Dval(dd001,Di1) + Dval(dd002,Di1) + Dval(dd003,Di1)
	d22sum = Dval(dd22,Di1) +
     &    Dval(dd122,Di1) + Dval(dd222,Di1) + Dval(dd223,Di1)
	d33sum = Dval(dd33,Di1) +
     &    Dval(dd133,Di1) + Dval(dd233,Di1) + Dval(dd333,Di1)

	E(ee0) = XE0(p1, p2, p3, p4, p5,
     &    p1p2, p2p3, p3p4, p4p5, p5p1, m1, m2, m3, m4, m5)

	in(1) = f1*E(ee0) - Dval(dd0,Di1) + Dval(dd0,Di2)
	in(2) = f2*E(ee0) - Dval(dd0,Di1) + Dval(dd0,Di3)
	in(3) = f3*E(ee0) - Dval(dd0,Di1) + Dval(dd0,Di4)
	in(4) = f4*E(ee0) - Dval(dd0,Di1) + Dval(dd0,Di5)
	call XLUBackSubst(G, 4, perm, in)
	E(ee1) = in(1)
	E(ee2) = in(2)
	E(ee3) = in(3)
	E(ee4) = in(4)

	E(ee00) = 0

	in(1) = f1*E(ee1) + d0sum
	in(2) = f2*E(ee1) + d0sum + Dval(dd1,Di3)
	in(3) = f3*E(ee1) + d0sum + Dval(dd1,Di4)
	in(4) = f4*E(ee1) + d0sum + Dval(dd1,Di5)
	call XLUBackSubst(G, 4, perm, in)
	E(ee11) = in(1)
	E(ee12) = in(2)
	E(ee13) = in(3)
	E(ee14) = in(4)

	in(1) = f1*E(ee2) - Dval(dd1,Di1) + Dval(dd1,Di2)
	in(2) = f2*E(ee2) - Dval(dd1,Di1)
	in(3) = f3*E(ee2) - Dval(dd1,Di1) + Dval(dd2,Di4)
	in(4) = f4*E(ee2) - Dval(dd1,Di1) + Dval(dd2,Di5)
	call XLUBackSubst(G, 4, perm, in)
	E(ee12) = .5D0*(E(ee12) + in(1))
	E(ee22) = in(2)
	E(ee23) = in(3)
	E(ee24) = in(4)

	in(1) = f1*E(ee3) - Dval(dd2,Di1) + Dval(dd2,Di2)
	in(2) = f2*E(ee3) - Dval(dd2,Di1) + Dval(dd2,Di3)
	in(3) = f3*E(ee3) - Dval(dd2,Di1)
	in(4) = f4*E(ee3) - Dval(dd2,Di1) + Dval(dd3,Di5)
	call XLUBackSubst(G, 4, perm, in)
	E(ee13) = .5D0*(E(ee13) + in(1))
	E(ee23) = .5D0*(E(ee23) + in(2))
	E(ee33) = in(3)
	E(ee34) = in(4)

	in(1) = f1*E(ee4) - Dval(dd3,Di1) + Dval(dd3,Di2)
	in(2) = f2*E(ee4) - Dval(dd3,Di1) + Dval(dd3,Di3)
	in(3) = f3*E(ee4) - Dval(dd3,Di1) + Dval(dd3,Di4)
	in(4) = f4*E(ee4) - Dval(dd3,Di1)
	call XLUBackSubst(G, 4, perm, in)
	E(ee14) = .5D0*(E(ee14) + in(1))
	E(ee24) = .5D0*(E(ee24) + in(2))
	E(ee34) = .5D0*(E(ee34) + in(3))
	E(ee44) = in(4)

	E(ee001) = 0
	E(ee002) = 0
	E(ee003) = 0
	E(ee004) = 0

	d0sum = d0sum + di + dii
	in(1) = f1*E(ee11) - d0sum -
     &    2*Y(1,1)*(Dval(dd00,Di1) - Dval(dd00,Di2))
	in(2) = f2*E(ee11) - d0sum + Dval(dd11,Di3) -
     &    2*Y(1,1)*(Dval(dd00,Di1) - Dval(dd00,Di3))
	in(3) = f3*E(ee11) - d0sum + Dval(dd11,Di4) -
     &    2*Y(1,1)*(Dval(dd00,Di1) - Dval(dd00,Di4))
	in(4) = f4*E(ee11) - d0sum + Dval(dd11,Di5) -
     &    2*Y(1,1)*(Dval(dd00,Di1) - Dval(dd00,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee111) = in(1)
	E(ee112) = in(2)
	E(ee113) = in(3)
	E(ee114) = in(4)

	in(1) = f1*E(ee22) - Dval(dd11,Di1) + Dval(dd11,Di2) -
     &    2*Y(2,2)*(Dval(dd00,Di1) - Dval(dd00,Di2))
	in(2) = f2*E(ee22) - Dval(dd11,Di1) -
     &    2*Y(2,2)*(Dval(dd00,Di1) - Dval(dd00,Di3))
	in(3) = f3*E(ee22) - Dval(dd11,Di1) + Dval(dd22,Di4) -
     &    2*Y(2,2)*(Dval(dd00,Di1) - Dval(dd00,Di4))
	in(4) = f4*E(ee22) - Dval(dd11,Di1) + Dval(dd22,Di5) -
     &    2*Y(2,2)*(Dval(dd00,Di1) - Dval(dd00,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee122) = in(1)
	E(ee222) = in(2)
	E(ee223) = in(3)
	E(ee224) = in(4)

	in(1) = f1*E(ee33) - Dval(dd22,Di1) + Dval(dd22,Di2) -
     &    2*Y(3,3)*(Dval(dd00,Di1) - Dval(dd00,Di2))
	in(2) = f2*E(ee33) - Dval(dd22,Di1) + Dval(dd22,Di3) -
     &    2*Y(3,3)*(Dval(dd00,Di1) - Dval(dd00,Di3))
	in(3) = f3*E(ee33) - Dval(dd22,Di1) -
     &    2*Y(3,3)*(Dval(dd00,Di1) - Dval(dd00,Di4))
	in(4) = f4*E(ee33) - Dval(dd22,Di1) + Dval(dd33,Di5) -
     &    2*Y(3,3)*(Dval(dd00,Di1) - Dval(dd00,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee133) = in(1)
	E(ee233) = in(2)
	E(ee333) = in(3)
	E(ee334) = in(4)

	in(1) = f1*E(ee44) - Dval(dd33,Di1) + Dval(dd33,Di2) -
     &    2*Y(4,4)*(Dval(dd00,Di1) - Dval(dd00,Di2))
	in(2) = f2*E(ee44) - Dval(dd33,Di1) + Dval(dd33,Di3) -
     &    2*Y(4,4)*(Dval(dd00,Di1) - Dval(dd00,Di3))
	in(3) = f3*E(ee44) - Dval(dd33,Di1) + Dval(dd33,Di4) -
     &    2*Y(4,4)*(Dval(dd00,Di1) - Dval(dd00,Di4))
	in(4) = f4*E(ee44) - Dval(dd33,Di1) -
     &    2*Y(4,4)*(Dval(dd00,Di1) - Dval(dd00,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee144) = in(1)
	E(ee244) = in(2)
	E(ee344) = in(3)
	E(ee444) = in(4)

	in(1) = f1*E(ee12) + d1sum -
     &    2*Y(1,2)*(Dval(dd00,Di1) - Dval(dd00,Di2))
	in(2) = f2*E(ee12) + d1sum -
     &    2*Y(1,2)*(Dval(dd00,Di1) - Dval(dd00,Di3))
	in(3) = f3*E(ee12) + d1sum + Dval(dd12,Di4) -
     &    2*Y(1,2)*(Dval(dd00,Di1) - Dval(dd00,Di4))
	in(4) = f4*E(ee12) + d1sum + Dval(dd12,Di5) -
     &    2*Y(1,2)*(Dval(dd00,Di1) - Dval(dd00,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee112) = .5D0*(E(ee112) + in(1))
	E(ee122) = .5D0*(E(ee122) + in(2))
	E(ee123) = in(3)
	E(ee124) = in(4)

	in(1) = f1*E(ee34) - Dval(dd23,Di1) + Dval(dd23,Di2) -
     &    2*Y(3,4)*(Dval(dd00,Di1) - Dval(dd00,Di2))
	in(2) = f2*E(ee34) - Dval(dd23,Di1) + Dval(dd23,Di3) -
     &    2*Y(3,4)*(Dval(dd00,Di1) - Dval(dd00,Di3))
	in(3) = f3*E(ee34) - Dval(dd23,Di1) -
     &    2*Y(3,4)*(Dval(dd00,Di1) - Dval(dd00,Di4))
	in(4) = f4*E(ee34) - Dval(dd23,Di1) -
     &    2*Y(3,4)*(Dval(dd00,Di1) - Dval(dd00,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee134) = in(1)
	E(ee234) = in(2)
	E(ee334) = .5D0*(E(ee334) + in(3))
	E(ee344) = .5D0*(E(ee344) + in(4))

	E(ee0000) = 0
	E(ee0011) = 0
	E(ee0012) = 0
	E(ee0013) = 0
	E(ee0014) = 0
	E(ee0022) = 0
	E(ee0023) = 0
	E(ee0024) = 0
	E(ee0033) = 0
	E(ee0034) = 0
	E(ee0044) = 0

	d0sum = d0sum + di + 2*dii + diii
	in(1) = f1*E(ee111) + d0sum +
     &    6*Y(1,1)*d00sum
	in(2) = f2*E(ee111) + d0sum + Dval(dd111,Di3) +
     &    6*Y(1,1)*(d00sum + Dval(dd001,Di3))
	in(3) = f3*E(ee111) + d0sum + Dval(dd111,Di4) +
     &    6*Y(1,1)*(d00sum + Dval(dd001,Di4))
	in(4) = f4*E(ee111) + d0sum + Dval(dd111,Di5) +
     &    6*Y(1,1)*(d00sum + Dval(dd001,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1111) = in(1)
	E(ee1112) = in(2)
	E(ee1113) = in(3)
	E(ee1114) = in(4)

	in(1) = f1*E(ee222) - Dval(dd111,Di1) + Dval(dd111,Di2) -
     &    6*Y(2,2)*(Dval(dd001,Di1) - Dval(dd001,Di2))
	in(2) = f2*E(ee222) - Dval(dd111,Di1) -
     &    6*Y(2,2)*Dval(dd001,Di1)
	in(3) = f3*E(ee222) - Dval(dd111,Di1) + Dval(dd222,Di4) -
     &    6*Y(2,2)*(Dval(dd001,Di1) - Dval(dd002,Di4))
	in(4) = f4*E(ee222) - Dval(dd111,Di1) + Dval(dd222,Di5) -
     &    6*Y(2,2)*(Dval(dd001,Di1) - Dval(dd002,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1222) = in(1)
	E(ee2222) = in(2)
	E(ee2223) = in(3)
	E(ee2224) = in(4)

	in(1) = f1*E(ee333) - Dval(dd222,Di1) + Dval(dd222,Di2) -
     &    6*Y(3,3)*(Dval(dd002,Di1) - Dval(dd002,Di2))
	in(2) = f2*E(ee333) - Dval(dd222,Di1) + Dval(dd222,Di3) -
     &    6*Y(3,3)*(Dval(dd002,Di1) - Dval(dd002,Di3))
	in(3) = f3*E(ee333) - Dval(dd222,Di1) -
     &    6*Y(3,3)*Dval(dd002,Di1)
	in(4) = f4*E(ee333) - Dval(dd222,Di1) + Dval(dd333,Di5) -
     &    6*Y(3,3)*(Dval(dd002,Di1) - Dval(dd003,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1333) = in(1)
	E(ee2333) = in(2)
	E(ee3333) = in(3)
	E(ee3334) = in(4)

	in(1) = f1*E(ee444) - Dval(dd333,Di1) + Dval(dd333,Di2) -
     &    6*Y(4,4)*(Dval(dd003,Di1) - Dval(dd003,Di2))
	in(2) = f2*E(ee444) - Dval(dd333,Di1) + Dval(dd333,Di3) -
     &    6*Y(4,4)*(Dval(dd003,Di1) - Dval(dd003,Di3))
	in(3) = f3*E(ee444) - Dval(dd333,Di1) + Dval(dd333,Di4) -
     &    6*Y(4,4)*(Dval(dd003,Di1) - Dval(dd003,Di4))
	in(4) = f4*E(ee444) - Dval(dd333,Di1) -
     &    6*Y(4,4)*Dval(dd003,Di1)
	call XLUBackSubst(G, 4, perm, in)
	E(ee1444) = in(1)
	E(ee2444) = in(2)
	E(ee3444) = in(3)
	E(ee4444) = in(4)

	d1sum = d1sum + d1i + d1ii
	in(1) = f1*E(ee112) - d1sum -
     &    2*Y(1,1)*(Dval(dd001,Di1) - Dval(dd001,Di2)) +
     &    4*Y(1,2)*d00sum
	in(2) = f2*E(ee112) - d1sum -
     &    2*Y(1,1)*Dval(dd001,Di1) +
     &    4*Y(1,2)*(d00sum + Dval(dd001,Di3))
	in(3) = f3*E(ee112) - d1sum + Dval(dd112,Di4) -
     &    2*Y(1,1)*(Dval(dd001,Di1) - Dval(dd002,Di4)) +
     &    4*Y(1,2)*(d00sum + Dval(dd001,Di4))
	in(4) = f4*E(ee112) - d1sum + Dval(dd112,Di5) -
     &    2*Y(1,1)*(Dval(dd001,Di1) - Dval(dd002,Di5)) +
     &    4*Y(1,2)*(d00sum + Dval(dd001,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1112) = .5D0*(E(ee1112) + in(1))
	E(ee1122) = in(2)
	E(ee1123) = in(3)
	E(ee1124) = in(4)

	in(1) = f1*E(ee223) - Dval(dd112,Di1) + Dval(dd112,Di2) -
     &    2*Y(2,2)*(Dval(dd002,Di1) - Dval(dd002,Di2)) -
     &    4*Y(2,3)*(Dval(dd001,Di1) - Dval(dd001,Di2))
	in(2) = f2*E(ee223) - Dval(dd112,Di1) -
     &    2*Y(2,2)*(Dval(dd002,Di1) - Dval(dd002,Di3)) -
     &    4*Y(2,3)*Dval(dd001,Di1)
	in(3) = f3*E(ee223) - Dval(dd112,Di1) -
     &    2*Y(2,2)*Dval(dd002,Di1) -
     &    4*Y(2,3)*(Dval(dd001,Di1) - Dval(dd002,Di4))
	in(4) = f4*E(ee223) - Dval(dd112,Di1) + Dval(dd223,Di5) -
     &    2*Y(2,2)*(Dval(dd002,Di1) - Dval(dd003,Di5)) -
     &    4*Y(2,3)*(Dval(dd001,Di1) - Dval(dd002,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1223) = in(1)
	E(ee2223) = .5D0*(E(ee2223) + in(2))
	E(ee2233) = in(3)
	E(ee2234) = in(4)

	in(1) = f1*E(ee334) - Dval(dd223,Di1) + Dval(dd223,Di2) -
     &    2*Y(3,3)*(Dval(dd003,Di1) - Dval(dd003,Di2)) -
     &    4*Y(3,4)*(Dval(dd002,Di1) - Dval(dd002,Di2))
	in(2) = f2*E(ee334) - Dval(dd223,Di1) + Dval(dd223,Di3) -
     &    2*Y(3,3)*(Dval(dd003,Di1) - Dval(dd003,Di3)) -
     &    4*Y(3,4)*(Dval(dd002,Di1) - Dval(dd002,Di3))
	in(3) = f3*E(ee334) - Dval(dd223,Di1) -
     &    2*Y(3,3)*(Dval(dd003,Di1) - Dval(dd003,Di4)) -
     &    4*Y(3,4)*Dval(dd002,Di1)
	in(4) = f4*E(ee334) - Dval(dd223,Di1) -
     &    2*Y(3,3)*Dval(dd003,Di1) -
     &    4*Y(3,4)*(Dval(dd002,Di1) - Dval(dd003,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1334) = in(1)
	E(ee2334) = in(2)
	E(ee3334) = .5D0*(E(ee3334) + in(3))
	E(ee3344) = in(4)

	in(1) = f1*E(ee144) + d33sum -
     &    4*Y(1,4)*(Dval(dd003,Di1) - Dval(dd003,Di2)) +
     &    2*Y(4,4)*d00sum
	in(2) = f2*E(ee144) + d33sum + Dval(dd133,Di3) -
     &    4*Y(1,4)*(Dval(dd003,Di1) - Dval(dd003,Di3)) +
     &    2*Y(4,4)*(d00sum + Dval(dd001,Di3))
	in(3) = f3*E(ee144) + d33sum + Dval(dd133,Di4) -
     &    4*Y(1,4)*(Dval(dd003,Di1) - Dval(dd003,Di4)) +
     &    2*Y(4,4)*(d00sum + Dval(dd001,Di4))
	in(4) = f4*E(ee144) + d33sum -
     &    4*Y(1,4)*Dval(dd003,Di1) +
     &    2*Y(4,4)*(d00sum + Dval(dd001,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1144) = in(1)
	E(ee1244) = in(2)
	E(ee1344) = in(3)
	E(ee1444) = .5D0*(E(ee1444) + in(4))

	d2sum = d2sum + d2i + d2ii
	in(1) = f1*E(ee113) - d2sum -
     &    2*Y(1,1)*(Dval(dd002,Di1) - Dval(dd002,Di2)) +
     &    4*Y(1,3)*d00sum
	in(2) = f2*E(ee113) - d2sum + Dval(dd112,Di3) -
     &    2*Y(1,1)*(Dval(dd002,Di1) - Dval(dd002,Di3)) +
     &    4*Y(1,3)*(d00sum + Dval(dd001,Di3))
	in(3) = f3*E(ee113) - d2sum -
     &    2*Y(1,1)*Dval(dd002,Di1) +
     &    4*Y(1,3)*(d00sum + Dval(dd001,Di4))
	in(4) = f4*E(ee113) - d2sum + Dval(dd113,Di5) -
     &    2*Y(1,1)*(Dval(dd002,Di1) - Dval(dd003,Di5)) +
     &    4*Y(1,3)*(d00sum + Dval(dd001,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1113) = .5D0*(E(ee1113) + in(1))
	E(ee1123) = .5D0*(E(ee1123) + in(2))
	E(ee1133) = in(3)
	E(ee1134) = in(4)

	in(1) = f1*E(ee224) - Dval(dd113,Di1) + Dval(dd113,Di2) -
     &    2*Y(2,2)*(Dval(dd003,Di1) - Dval(dd003,Di2)) -
     &    4*Y(2,4)*(Dval(dd001,Di1) - Dval(dd001,Di2))
	in(2) = f2*E(ee224) - Dval(dd113,Di1) -
     &    2*Y(2,2)*(Dval(dd003,Di1) - Dval(dd003,Di3)) -
     &    4*Y(2,4)*Dval(dd001,Di1)
	in(3) = f3*E(ee224) - Dval(dd113,Di1) + Dval(dd223,Di4) -
     &    2*Y(2,2)*(Dval(dd003,Di1) - Dval(dd003,Di4)) -
     &    4*Y(2,4)*(Dval(dd001,Di1) - Dval(dd002,Di4))
	in(4) = f4*E(ee224) - Dval(dd113,Di1) -
     &    2*Y(2,2)*Dval(dd003,Di1) -
     &    4*Y(2,4)*(Dval(dd001,Di1) - Dval(dd002,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1224) = in(1)
	E(ee2224) = .5D0*(E(ee2224) + in(2))
	E(ee2234) = E(ee2234) + in(3)
	E(ee2244) = in(4)

	in(1) = f1*E(ee234) - Dval(dd123,Di1) + Dval(dd123,Di2) -
     &    2*Y(2,3)*(Dval(dd003,Di1) - Dval(dd003,Di2)) -
     &    2*Y(3,4)*(Dval(dd001,Di1) - Dval(dd001,Di2)) -
     &    2*Y(2,4)*(Dval(dd002,Di1) - Dval(dd002,Di2))
	in(2) = f2*E(ee234) - Dval(dd123,Di1) -
     &    2*Y(2,3)*(Dval(dd003,Di1) - Dval(dd003,Di3)) -
     &    2*Y(3,4)*Dval(dd001,Di1) -
     &    2*Y(2,4)*(Dval(dd002,Di1) - Dval(dd002,Di3))
	in(3) = f3*E(ee234) - Dval(dd123,Di1) -
     &    2*Y(2,3)*(Dval(dd003,Di1) - Dval(dd003,Di4)) -
     &    2*Y(3,4)*(Dval(dd001,Di1) - Dval(dd002,Di4)) -
     &    2*Y(2,4)*Dval(dd002,Di1)
	in(4) = f4*E(ee234) - Dval(dd123,Di1) -
     &    2*Y(2,3)*Dval(dd003,Di1) -
     &    2*Y(3,4)*(Dval(dd001,Di1) - Dval(dd002,Di5)) -
     &    2*Y(2,4)*(Dval(dd002,Di1) - Dval(dd003,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1234) = in(1)
	E(ee2234) = 1/3D0*(E(ee2234) + in(2))
	E(ee2334) = .5D0*(E(ee2334) + in(3))
	E(ee2344) = in(4)

	in(1) = f1*E(ee133) + d22sum -
     &    4*Y(1,3)*(Dval(dd002,Di1) - Dval(dd002,Di2)) +
     &    2*Y(3,3)*d00sum
	in(2) = f2*E(ee133) + d22sum + Dval(dd122,Di3) -
     &    4*Y(1,3)*(Dval(dd002,Di1) - Dval(dd002,Di3)) +
     &    2*Y(3,3)*(d00sum + Dval(dd001,Di3))
	in(3) = f3*E(ee133) + d22sum -
     &    4*Y(1,3)*Dval(dd002,Di1) +
     &    2*Y(3,3)*(d00sum + Dval(dd001,Di4))
	in(4) = f4*E(ee133) + d22sum + Dval(dd133,Di5) -
     &    4*Y(1,3)*(Dval(dd002,Di1) - Dval(dd003,Di5)) +
     &    2*Y(3,3)*(d00sum + Dval(dd001,Di5))
	call XLUBackSubst(G, 4, perm, in)
	E(ee1133) = .5D0*(E(ee1133) + in(1))
	E(ee1233) = in(2)
	E(ee1333) = .5D0*(E(ee1333) + in(3))
	E(ee1334) = .5D0*(E(ee1334) + in(4))

	if( dump ) call XDumpCoeff(5, E)
	end

