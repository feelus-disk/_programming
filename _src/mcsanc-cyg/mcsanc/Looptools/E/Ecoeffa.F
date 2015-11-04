* Ecoeffa.F
* the five-point tensor coefficients
* this file is part of LoopTools
* written by M. Rauch
* last modified 7 Dec 05 th

#include "defs.h"


	subroutine XEcoeffa(para, E, ldpara)
	implicit none
	integer ldpara
	DVAR para(ldpara,Pee)
	double complex E(Nee)

#include "lt.h"

	integer XDget
	double complex XE0
	QVAR XDet
	external XDget, XE0, XDet

	DVAR p1, p2, p3, p4, p5
	DVAR p1p2, p2p3, p3p4, p4p5, p5p1
	DVAR m1, m2, m3, m4, m5
	QVAR Y(5,5), Yi(5,5), Z(4,4), Zij(3,3)
	QVAR eta(5), zeta(4,4), detY, detZ
	double precision del, del4
	integer i, j, k, l
	integer Di1, Di2, Di3, Di4, Di5
	logical dump

	QVAR Yflat(25), Yiflat(25)
	equivalence (Y, Yflat)
	equivalence (Yi, Yiflat)

	double complex help1, help2, help3, help4
	double complex dabbr41, dabbr48, dabbr65, dabbr60, dabbr55
	double complex dabbr50, dabbr49, dabbr45, dabbr42, dabbr10
	double complex dabbr84, dabbr91, dabbr81, dabbr52, dabbr88
	double complex dabbr77, dabbr90, dabbr46, dabbr87, dabbr74
	double complex dabbr80, dabbr71, dabbr83, dabbr76, dabbr79
	double complex dabbr43, dabbr70, dabbr73, dabbr35, dabbr37
	double complex dabbr39, dabbr27, dabbr31, dabbr24, dabbr20
	double complex dabbr16, dabbr30, dabbr13, dabbr23, dabbr26
	double complex dabbr5, dabbr7, dabbr9, dabbr33, dabbr92
	double complex dabbr89, dabbr86, dabbr85, dabbr82, dabbr78
	double complex dabbr75, dabbr72, dabbr69, dabbr68, dabbr38
	double complex dabbr36, dabbr34, dabbr32, dabbr29, dabbr28
	double complex dabbr25, dabbr22, dabbr21, dabbr3, dabbr8
	double complex dabbr6, dabbr4, dabbr1, dabbr61, dabbr66
	double complex dabbr57, dabbr47, dabbr51, dabbr64, dabbr44
	double complex dabbr56, dabbr59, dabbr14, dabbr17, dabbr19
	double complex dabbr67, dabbr63, dabbr62, dabbr58, dabbr54
	double complex dabbr53, dabbr11, dabbr18, dabbr15, dabbr12
	double complex dabbr2, dabbr40

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
	  call Ecoeffa(para, E, 2)
	  return
	endif
#endif

	Di1 = XDget(p2, p3, p4, p5p1, p2p3, p3p4, m2, m3, m4, m5)
	Di1 = XDget(p2, p3, p4, p5p1, p2p3, p3p4, m2, m3, m4, m5)
	Di2 = XDget(p1p2, p3, p4, p5, p4p5, p3p4, m1, m3, m4, m5)
	Di3 = XDget(p1, p2p3, p4, p5, p4p5, p5p1, m1, m2, m4, m5)
	Di4 = XDget(p1, p2, p3p4, p5, p1p2, p5p1, m1, m2, m3, m5)
	Di5 = XDget(p1, p2, p3, p4p5, p1p2, p2p3, m1, m2, m3, m4)

	serial = serial + 1
	dump = ibits(debugkey, DebugE, 1) .ne. 0 .and.
     &    serial .ge. debugfrom .and. serial .le. debugto
	if( dump ) call XDumpPara(5, para, ldpara, "Ecoeffa")

	Y(1,1) = 2*QEXT(m1)
	Y(2,2) = 2*QEXT(m2)
	Y(3,3) = 2*QEXT(m3)
	Y(4,4) = 2*QEXT(m4)
	Y(5,5) = 2*QEXT(m5)
	Y(1,2) = QEXT(m1) + QEXT(m2) - QEXT(p1)
	Y(2,1) = Y(1,2)
	Y(1,3) = QEXT(m1) + QEXT(m3) - QEXT(p1p2)
	Y(3,1) = Y(1,3)
	Y(1,4) = QEXT(m1) + QEXT(m4) - QEXT(p4p5)
	Y(4,1) = Y(1,4)
	Y(1,5) = QEXT(m1) + QEXT(m5) - QEXT(p5)
	Y(5,1) = Y(1,5)
	Y(2,3) = QEXT(m2) + QEXT(m3) - QEXT(p2)
	Y(3,2) = Y(2,3)
	Y(2,4) = QEXT(m2) + QEXT(m4) - QEXT(p2p3)
	Y(4,2) = Y(2,4)
	Y(2,5) = QEXT(m2) + QEXT(m5) - QEXT(p5p1)
	Y(5,2) = Y(2,5)
	Y(3,4) = QEXT(m3) + QEXT(m4) - QEXT(p3)
	Y(4,3) = Y(3,4)
	Y(3,5) = QEXT(m3) + QEXT(m5) - QEXT(p3p4)
	Y(5,3) = Y(3,5)
	Y(4,5) = QEXT(m4) + QEXT(m5) - QEXT(p4)
	Y(5,4) = Y(4,5)

* calculate the Y(i), their determinants, and eta(i)
	do i = 1, 5
	  do j = 1, 25
	    Yiflat(j) = Yflat(j)
	  enddo
	  do j = 1, 5
	    Yi(j,i) = 1
	  enddo
	  eta(i) = XDet(Yi, 5)
	enddo

* Y is no longer needed, now calculate its determinant and
* add the missing factor 1/detY to eta
	detY = XDet(Y, 5)
	do i = 1, 5
	  eta(i) = eta(i)/detY
	enddo

	Z(1,1) = 2*QEXT(p1)
	Z(2,2) = 2*QEXT(p1p2)
	Z(3,3) = 2*QEXT(p4p5)
	Z(4,4) = 2*QEXT(p5)
	Z(1,2) = QEXT(p1) + QEXT(p1p2) - QEXT(p2)
	Z(2,1) = Z(1,2)
	Z(1,3) = QEXT(p1) - QEXT(p2p3) + QEXT(p4p5)
	Z(3,1) = Z(1,3)
	Z(1,4) = QEXT(p1) - QEXT(p5p1) + QEXT(p5)
	Z(4,1) = Z(1,4)
	Z(2,3) = QEXT(p1p2) - QEXT(p3) + QEXT(p4p5)
	Z(3,2) = Z(2,3)
	Z(2,4) = QEXT(p1p2) - QEXT(p3p4) + QEXT(p5)
	Z(4,2) = Z(2,4)
	Z(3,4) = QEXT(p5) + QEXT(p4p5) - QEXT(p4)
	Z(4,3) = Z(3,4)

* calculate the zeta(i,j)
	do i = 1, 4
	  do j = i, 4
* generate the submatrix Z_ij
	    do k = 1, 3
	      do l = 1, 3
	        Zij(k,l) = Z(k + ibits(not(k - i), 3, 1),
     &                       l + ibits(not(l - j), 3, 1))
	      enddo
	    enddo
	    zeta(i,j) = Sgn(i + j)*XDet(Zij, 3)/detY
	    zeta(j,i) = zeta(i,j)
	  enddo
	enddo
	detZ = XDet(Z, 4)

	del = (delta + log(mudim))/6D0
	del4 = .25D0*del

	help1 = Dval(dd003,Di1) + 2*Dval(dd0033,Di1) + 
     &   Dval(dd00333,Di1)
	help2 = Dval(dd002,Di1) + 2*Dval(dd0023,Di1) + 
     &   Dval(dd00233,Di1)
	help3 = Dval(dd001,Di1) + 2*Dval(dd0013,Di1) + 
     &   Dval(dd00133,Di1)
	help4 = Dval(dd00,Di1) + 2*Dval(dd003,Di1) + 
     &   Dval(dd0033,Di1)
	dabbr41 = Dval(dd00223,Di1) + Dval(dd00233,Di1)
	dabbr48 = Dval(dd00113,Di1) + Dval(dd00133,Di1)
	dabbr65 = Dval(dd0023,Di1) + Dval(dd00123,Di1)
	dabbr60 = Dval(dd0013,Di1) + Dval(dd00123,Di1)
	dabbr55 = Dval(dd0012,Di1) + Dval(dd00123,Di1)
	dabbr50 = Dval(dd00112,Di1) + Dval(dd00122,Di1)
	dabbr49 = Dval(dd2233,Di1) + Dval(dd2333,Di1)
	dabbr45 = Dval(dd2223,Di1) + Dval(dd2233,Di1)
	dabbr42 = Dval(dd1223,Di1) + Dval(dd1233,Di1)
	dabbr10 = Dval(dd223,Di1) + Dval(dd233,Di1)
	dabbr84 = Dval(dd0033,Di1) + Dval(dd00233,Di1) + 
     &   Dval(dd00333,Di1)
	dabbr91 = Dval(dd0033,Di1) + Dval(dd00133,Di1) + 
     &   Dval(dd00333,Di1)
	dabbr81 = dabbr41 + Dval(dd0023,Di1)
	dabbr52 = Dval(dd0033,Di1) + Dval(dd00133,Di1) + 
     &   Dval(dd00233,Di1)
	dabbr88 = dabbr65 + Dval(dd00233,Di1)
	dabbr77 = Dval(dd0022,Di1) + Dval(dd00222,Di1) + 
     &   Dval(dd00223,Di1)
	dabbr90 = dabbr65 + Dval(dd00223,Di1)
	dabbr46 = Dval(dd0022,Di1) + Dval(dd00122,Di1) + 
     &   Dval(dd00223,Di1)
	dabbr87 = Dval(dd0022,Di1) + Dval(dd00122,Di1) + 
     &   Dval(dd00222,Di1)
	dabbr74 = dabbr60 + Dval(dd00133,Di1)
	dabbr80 = dabbr48 + Dval(dd0013,Di1)
	dabbr71 = dabbr55 + Dval(dd00122,Di1)
	dabbr83 = dabbr60 + Dval(dd00113,Di1)
	dabbr76 = dabbr55 + Dval(dd00112,Di1)
	dabbr79 = dabbr50 + Dval(dd0012,Di1)
	dabbr43 = Dval(dd0011,Di1) + Dval(dd00112,Di1) + 
     &   Dval(dd00113,Di1)
	dabbr70 = Dval(dd0011,Di1) + Dval(dd00111,Di1) + 
     &   Dval(dd00113,Di1)
	dabbr73 = Dval(dd0011,Di1) + Dval(dd00111,Di1) + 
     &   Dval(dd00112,Di1)
	dabbr35 = (Dval(dd0000,Di1) - del) + 
     &   (Dval(dd00002,Di1) + del4) + 
     &   (Dval(dd00003,Di1) + del4)
	dabbr37 = (Dval(dd0000,Di1) - del) + 
     &   (Dval(dd00001,Di1) + del4) + 
     &   (Dval(dd00003,Di1) + del4)
	dabbr39 = (Dval(dd0000,Di1) - del) + 
     &   (Dval(dd00001,Di1) + del4) + 
     &   (Dval(dd00002,Di1) + del4)
	dabbr27 = Dval(dd003,Di1) + Dval(dd0023,Di1) + 
     &   Dval(dd0033,Di1)
	dabbr31 = Dval(dd003,Di1) + Dval(dd0013,Di1) + 
     &   Dval(dd0033,Di1)
	dabbr24 = Dval(dd002,Di1) + Dval(dd0022,Di1) + 
     &   Dval(dd0023,Di1)
	dabbr20 = Dval(dd003,Di1) + Dval(dd0013,Di1) + 
     &   Dval(dd0023,Di1)
	dabbr16 = Dval(dd002,Di1) + Dval(dd0012,Di1) + 
     &   Dval(dd0023,Di1)
	dabbr30 = Dval(dd002,Di1) + Dval(dd0012,Di1) + 
     &   Dval(dd0022,Di1)
	dabbr13 = Dval(dd001,Di1) + Dval(dd0012,Di1) + 
     &   Dval(dd0013,Di1)
	dabbr23 = Dval(dd001,Di1) + Dval(dd0011,Di1) + 
     &   Dval(dd0013,Di1)
	dabbr26 = Dval(dd001,Di1) + Dval(dd0011,Di1) + 
     &   Dval(dd0012,Di1)
	dabbr5 = Dval(dd00,Di1) + Dval(dd002,Di1) + 
     &   Dval(dd003,Di1)
	dabbr7 = Dval(dd00,Di1) + Dval(dd001,Di1) + 
     &   Dval(dd003,Di1)
	dabbr9 = Dval(dd00,Di1) + Dval(dd001,Di1) + 
     &   Dval(dd002,Di1)
	dabbr33 = dabbr35 + (Dval(dd00001,Di1) + del4)
	dabbr92 = Dval(dd333,Di1) + Dval(dd1333,Di1) + 
     &   Dval(dd2333,Di1) + Dval(dd3333,Di1)
	dabbr89 = dabbr49 + Dval(dd233,Di1) + Dval(dd1233,Di1)
	dabbr86 = dabbr45 + Dval(dd223,Di1) + Dval(dd1223,Di1)
	dabbr85 = Dval(dd222,Di1) + Dval(dd1222,Di1) + 
     &   Dval(dd2222,Di1) + Dval(dd2223,Di1)
	dabbr82 = Dval(dd133,Di1) + Dval(dd1133,Di1) + 
     &   Dval(dd1233,Di1) + Dval(dd1333,Di1)
	dabbr78 = dabbr42 + Dval(dd123,Di1) + Dval(dd1123,Di1)
	dabbr75 = Dval(dd122,Di1) + Dval(dd1122,Di1) + 
     &   Dval(dd1222,Di1) + Dval(dd1223,Di1)
	dabbr72 = Dval(dd113,Di1) + Dval(dd1113,Di1) + 
     &   Dval(dd1123,Di1) + Dval(dd1133,Di1)
	dabbr69 = Dval(dd112,Di1) + Dval(dd1112,Di1) + 
     &   Dval(dd1122,Di1) + Dval(dd1123,Di1)
	dabbr68 = Dval(dd111,Di1) + Dval(dd1111,Di1) + 
     &   Dval(dd1112,Di1) + Dval(dd1113,Di1)
	dabbr38 = dabbr27 + Dval(dd0013,Di1)
	dabbr36 = dabbr24 + Dval(dd0012,Di1)
	dabbr34 = dabbr13 + Dval(dd0011,Di1)
	dabbr32 = Dval(dd33,Di1) + Dval(dd133,Di1) + 
     &   Dval(dd233,Di1) + Dval(dd333,Di1)
	dabbr29 = dabbr10 + Dval(dd23,Di1) + Dval(dd123,Di1)
	dabbr28 = Dval(dd22,Di1) + Dval(dd122,Di1) + 
     &   Dval(dd222,Di1) + Dval(dd223,Di1)
	dabbr25 = Dval(dd13,Di1) + Dval(dd113,Di1) + 
     &   Dval(dd123,Di1) + Dval(dd133,Di1)
	dabbr22 = Dval(dd12,Di1) + Dval(dd112,Di1) + 
     &   Dval(dd122,Di1) + Dval(dd123,Di1)
	dabbr21 = Dval(dd11,Di1) + Dval(dd111,Di1) + 
     &   Dval(dd112,Di1) + Dval(dd113,Di1)
	dabbr3 = dabbr5 + Dval(dd001,Di1)
	dabbr8 = Dval(dd3,Di1) + Dval(dd13,Di1) + 
     &   Dval(dd23,Di1) + Dval(dd33,Di1)
	dabbr6 = Dval(dd2,Di1) + Dval(dd12,Di1) + 
     &   Dval(dd22,Di1) + Dval(dd23,Di1)
	dabbr4 = Dval(dd1,Di1) + Dval(dd11,Di1) + 
     &   Dval(dd12,Di1) + Dval(dd13,Di1)
	dabbr1 = Dval(dd0,Di1) + Dval(dd1,Di1) + 
     &   Dval(dd2,Di1) + Dval(dd3,Di1)
	dabbr61 = help1 + 2*Dval(dd0023,Di1) + 
     &   Dval(dd00223,Di1) + 2*Dval(dd00233,Di1)
	dabbr66 = help1 + 2*Dval(dd0013,Di1) + 
     &   Dval(dd00113,Di1) + 2*Dval(dd00133,Di1)
	dabbr57 = help2 + 2*Dval(dd0022,Di1) + 
     &   Dval(dd00222,Di1) + 2*Dval(dd00223,Di1)
	dabbr47 = help2 + 2*Dval(dd0012,Di1) + 
     &   Dval(dd00112,Di1) + 2*Dval(dd00123,Di1)
	dabbr51 = Dval(dd003,Di1) + 2*Dval(dd0013,Di1) + 
     &   2*Dval(dd0023,Di1) + Dval(dd00113,Di1) + 
     &   2*Dval(dd00123,Di1) + Dval(dd00223,Di1)
	dabbr64 = Dval(dd002,Di1) + 2*Dval(dd0012,Di1) + 
     &   2*Dval(dd0022,Di1) + Dval(dd00112,Di1) + 
     &   2*Dval(dd00122,Di1) + Dval(dd00222,Di1)
	dabbr44 = help3 + 2*Dval(dd0012,Di1) + 
     &   Dval(dd00122,Di1) + 2*Dval(dd00123,Di1)
	dabbr56 = help3 + 2*Dval(dd0011,Di1) + 
     &   Dval(dd00111,Di1) + 2*Dval(dd00113,Di1)
	dabbr59 = Dval(dd001,Di1) + 2*Dval(dd0011,Di1) + 
     &   2*Dval(dd0012,Di1) + Dval(dd00111,Di1) + 
     &   2*Dval(dd00112,Di1) + Dval(dd00122,Di1)
	dabbr14 = help4 + 2*Dval(dd002,Di1) + 
     &   Dval(dd0022,Di1) + 2*Dval(dd0023,Di1)
	dabbr17 = help4 + 2*Dval(dd001,Di1) + 
     &   Dval(dd0011,Di1) + 2*Dval(dd0013,Di1)
	dabbr19 = Dval(dd00,Di1) + 2*Dval(dd001,Di1) + 
     &   2*Dval(dd002,Di1) + Dval(dd0011,Di1) + 
     &   2*Dval(dd0012,Di1) + Dval(dd0022,Di1)
	dabbr67 = Dval(dd33,Di1) + 2*Dval(dd133,Di1) + 
     &   2*Dval(dd233,Di1) + 2*Dval(dd333,Di1) + 
     &   Dval(dd1133,Di1) + 2*Dval(dd1233,Di1) + 
     &   2*Dval(dd1333,Di1) + Dval(dd2233,Di1) + 
     &   2*Dval(dd2333,Di1) + Dval(dd3333,Di1)
	dabbr63 = Dval(dd23,Di1) + 2*Dval(dd123,Di1) + 
     &   2*Dval(dd223,Di1) + 2*Dval(dd233,Di1) + 
     &   Dval(dd1123,Di1) + 2*Dval(dd1223,Di1) + 
     &   2*Dval(dd1233,Di1) + Dval(dd2223,Di1) + 
     &   2*Dval(dd2233,Di1) + Dval(dd2333,Di1)
	dabbr62 = Dval(dd22,Di1) + 2*Dval(dd122,Di1) + 
     &   2*Dval(dd222,Di1) + 2*Dval(dd223,Di1) + 
     &   Dval(dd1122,Di1) + 2*Dval(dd1222,Di1) + 
     &   2*Dval(dd1223,Di1) + Dval(dd2222,Di1) + 
     &   2*Dval(dd2223,Di1) + Dval(dd2233,Di1)
	dabbr58 = Dval(dd13,Di1) + 2*Dval(dd113,Di1) + 
     &   2*Dval(dd123,Di1) + 2*Dval(dd133,Di1) + 
     &   Dval(dd1113,Di1) + 2*Dval(dd1123,Di1) + 
     &   2*Dval(dd1133,Di1) + Dval(dd1223,Di1) + 
     &   2*Dval(dd1233,Di1) + Dval(dd1333,Di1)
	dabbr54 = Dval(dd12,Di1) + 2*Dval(dd112,Di1) + 
     &   2*Dval(dd122,Di1) + 2*Dval(dd123,Di1) + 
     &   Dval(dd1112,Di1) + 2*Dval(dd1122,Di1) + 
     &   2*Dval(dd1123,Di1) + Dval(dd1222,Di1) + 
     &   2*Dval(dd1223,Di1) + Dval(dd1233,Di1)
	dabbr53 = Dval(dd11,Di1) + 2*Dval(dd111,Di1) + 
     &   2*Dval(dd112,Di1) + 2*Dval(dd113,Di1) + 
     &   Dval(dd1111,Di1) + 2*Dval(dd1112,Di1) + 
     &   2*Dval(dd1113,Di1) + Dval(dd1122,Di1) + 
     &   2*Dval(dd1123,Di1) + Dval(dd1133,Di1)
	dabbr11 = dabbr14 + 2*Dval(dd001,Di1) + 
     &   Dval(dd0011,Di1) + 2*Dval(dd0012,Di1) + 
     &   2*Dval(dd0013,Di1)
	dabbr18 = Dval(dd3,Di1) + 2*Dval(dd13,Di1) + 
     &   2*Dval(dd23,Di1) + 2*Dval(dd33,Di1) + 
     &   Dval(dd113,Di1) + 2*Dval(dd123,Di1) + 
     &   2*Dval(dd133,Di1) + Dval(dd223,Di1) + 
     &   2*Dval(dd233,Di1) + Dval(dd333,Di1)
	dabbr15 = Dval(dd2,Di1) + 2*Dval(dd12,Di1) + 
     &   2*Dval(dd22,Di1) + 2*Dval(dd23,Di1) + 
     &   Dval(dd112,Di1) + 2*Dval(dd122,Di1) + 
     &   2*Dval(dd123,Di1) + Dval(dd222,Di1) + 
     &   2*Dval(dd223,Di1) + Dval(dd233,Di1)
	dabbr12 = Dval(dd1,Di1) + 2*Dval(dd11,Di1) + 
     &   2*Dval(dd12,Di1) + 2*Dval(dd13,Di1) + 
     &   Dval(dd111,Di1) + 2*Dval(dd112,Di1) + 
     &   2*Dval(dd113,Di1) + Dval(dd122,Di1) + 
     &   2*Dval(dd123,Di1) + Dval(dd133,Di1)
	dabbr2 = Dval(dd0,Di1) + 2*Dval(dd1,Di1) + 
     &   2*Dval(dd2,Di1) + 2*Dval(dd3,Di1) + 
     &   Dval(dd11,Di1) + 2*Dval(dd12,Di1) + 
     &   2*Dval(dd13,Di1) + Dval(dd22,Di1) + 
     &   2*Dval(dd23,Di1) + Dval(dd33,Di1)
	dabbr40 = Dval(dd0,Di1) + 4*Dval(dd1,Di1) + 
     &   4*Dval(dd2,Di1) + 4*Dval(dd3,Di1) + 
     &   6*Dval(dd11,Di1) + 12*Dval(dd12,Di1) + 
     &   12*Dval(dd13,Di1) + 6*Dval(dd22,Di1) + 
     &   12*Dval(dd23,Di1) + 6*Dval(dd33,Di1) + 
     &   4*Dval(dd111,Di1) + 12*Dval(dd112,Di1) + 
     &   12*Dval(dd113,Di1) + 12*Dval(dd122,Di1) + 
     &   24*Dval(dd123,Di1) + 12*Dval(dd133,Di1) + 
     &   4*Dval(dd222,Di1) + 12*Dval(dd223,Di1) + 
     &   12*Dval(dd233,Di1) + 4*Dval(dd333,Di1) + 
     &   Dval(dd1111,Di1) + 4*Dval(dd1112,Di1) + 
     &   4*Dval(dd1113,Di1) + 6*Dval(dd1122,Di1) + 
     &   12*Dval(dd1123,Di1) + 6*Dval(dd1133,Di1) + 
     &   4*Dval(dd1222,Di1) + 12*Dval(dd1223,Di1) + 
     &   12*Dval(dd1233,Di1) + 4*Dval(dd1333,Di1) + 
     &   Dval(dd2222,Di1) + 4*Dval(dd2223,Di1) + 
     &   6*Dval(dd2233,Di1) + 4*Dval(dd2333,Di1) + 
     &   Dval(dd3333,Di1)

	E(ee0) = XE0(p1, p2, p3, p4, p5, p1p2, p2p3, p3p4,
     &    p4p5, p5p1, m1, m2, m3, m4, m5)

	E(ee1) = dabbr1*eta(1) - eta(3)*Dval(dd1,Di3) - 
     &   eta(4)*Dval(dd1,Di4) - eta(5)*Dval(dd1,Di5) + 
     &   2*(zeta(1,1)*Dval(dd00,Di2) + 
     &      zeta(1,2)*Dval(dd00,Di3) + 
     &      zeta(1,3)*Dval(dd00,Di4) + 
     &      zeta(1,4)*Dval(dd00,Di5) - 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,3) + zeta(1,4))*
     &       Dval(dd00,Di1))
	E(ee2) = -(eta(2)*Dval(dd1,Di2)) - 
     &   eta(4)*Dval(dd2,Di4) - eta(5)*Dval(dd2,Di5) - 
     &   eta(1)*Dval(dd1,Di1) + 
     &   2*zeta(1,2)*Dval(dd00,Di2) + 
     &   2*zeta(2,2)*Dval(dd00,Di3) + 
     &   2*zeta(2,3)*Dval(dd00,Di4) + 
     &   2*zeta(2,4)*Dval(dd00,Di5) - 
     &   2*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd00,Di1)
	E(ee3) = -(eta(2)*Dval(dd2,Di2)) - 
     &   eta(3)*Dval(dd2,Di3) - eta(5)*Dval(dd3,Di5) - 
     &   eta(1)*Dval(dd2,Di1) + 
     &   2*zeta(1,3)*Dval(dd00,Di2) + 
     &   2*zeta(2,3)*Dval(dd00,Di3) + 
     &   2*zeta(3,3)*Dval(dd00,Di4) + 
     &   2*zeta(3,4)*Dval(dd00,Di5) - 
     &   2*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd00,Di1)
	E(ee4) = -(eta(2)*Dval(dd3,Di2)) - 
     &   eta(3)*Dval(dd3,Di3) - eta(4)*Dval(dd3,Di4) - 
     &   eta(1)*Dval(dd3,Di1) + 
     &   2*zeta(1,4)*Dval(dd00,Di2) + 
     &   2*zeta(2,4)*Dval(dd00,Di3) + 
     &   2*zeta(3,4)*Dval(dd00,Di4) + 
     &   2*zeta(4,4)*Dval(dd00,Di5) - 
     &   2*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd00,Di1)

	E(ee00) = -(eta(2)*Dval(dd00,Di2)) - 
     &   eta(3)*Dval(dd00,Di3) - eta(4)*Dval(dd00,Di4) - 
     &   eta(5)*Dval(dd00,Di5) - eta(1)*Dval(dd00,Di1)
	E(ee11) = -(dabbr2*eta(1)) - eta(3)*Dval(dd11,Di3) - 
     &   eta(4)*Dval(dd11,Di4) - eta(5)*Dval(dd11,Di5) + 
     &   4*(dabbr3*(zeta(1,1) + zeta(1,2) + zeta(1,3) + 
     &         zeta(1,4)) + zeta(1,2)*Dval(dd001,Di3) + 
     &      zeta(1,3)*Dval(dd001,Di4) + 
     &      zeta(1,4)*Dval(dd001,Di5))
	E(ee12) = dabbr4*eta(1) - eta(4)*Dval(dd12,Di4) - 
     &   eta(5)*Dval(dd12,Di5) + 
     &   2*(dabbr5*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + zeta(1,1)*Dval(dd001,Di2) + 
     &      zeta(2,2)*Dval(dd001,Di3) + 
     &      zeta(2,3)*Dval(dd001,Di4) + 
     &      zeta(2,4)*Dval(dd001,Di5) + 
     &      zeta(1,3)*Dval(dd002,Di4) + 
     &      zeta(1,4)*Dval(dd002,Di5) - 
     &      (zeta(1,1) + zeta(1,3) + zeta(1,4) - zeta(2,2) - 
     &         zeta(2,3) - zeta(2,4))*Dval(dd001,Di1))
	E(ee13) = dabbr6*eta(1) - eta(3)*Dval(dd12,Di3) - 
     &   eta(5)*Dval(dd13,Di5) + 
     &   2*(dabbr7*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + zeta(2,3)*Dval(dd001,Di3) + 
     &      zeta(3,3)*Dval(dd001,Di4) + 
     &      zeta(3,4)*Dval(dd001,Di5) + 
     &      zeta(1,1)*Dval(dd002,Di2) + 
     &      zeta(1,2)*Dval(dd002,Di3) + 
     &      zeta(1,4)*Dval(dd003,Di5) - 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,4) - zeta(2,3) - 
     &         zeta(3,3) - zeta(3,4))*Dval(dd002,Di1))
	E(ee14) = dabbr8*eta(1) - eta(3)*Dval(dd13,Di3) - 
     &   eta(4)*Dval(dd13,Di4) + 
     &   2*(dabbr9*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + zeta(2,4)*Dval(dd001,Di3) + 
     &      zeta(3,4)*Dval(dd001,Di4) + 
     &      zeta(4,4)*Dval(dd001,Di5) + 
     &      zeta(1,1)*Dval(dd003,Di2) + 
     &      zeta(1,2)*Dval(dd003,Di3) + 
     &      zeta(1,3)*Dval(dd003,Di4) - 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,3) - zeta(2,4) - 
     &         zeta(3,4) - zeta(4,4))*Dval(dd003,Di1))
	E(ee22) = -(eta(2)*Dval(dd11,Di2)) - 
     &   eta(4)*Dval(dd22,Di4) - eta(5)*Dval(dd22,Di5) - 
     &   eta(1)*Dval(dd11,Di1) + 
     &   4*zeta(1,2)*Dval(dd001,Di2) + 
     &   4*zeta(2,3)*Dval(dd002,Di4) + 
     &   4*zeta(2,4)*Dval(dd002,Di5) - 
     &   4*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd001,Di1)
	E(ee23) = -(eta(2)*Dval(dd12,Di2)) - 
     &   eta(5)*Dval(dd23,Di5) - eta(1)*Dval(dd12,Di1) + 
     &   2*(zeta(1,3)*Dval(dd001,Di2) + 
     &      zeta(1,2)*Dval(dd002,Di2) + 
     &      zeta(2,2)*Dval(dd002,Di3) + 
     &      zeta(3,3)*Dval(dd002,Di4) + 
     &      zeta(3,4)*Dval(dd002,Di5) + 
     &      zeta(2,4)*Dval(dd003,Di5) - 
     &      (zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd001,Di1) - 
     &      (zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       Dval(dd002,Di1))
	E(ee24) = -(eta(2)*Dval(dd13,Di2)) - 
     &   eta(4)*Dval(dd23,Di4) - eta(1)*Dval(dd13,Di1) + 
     &   2*(zeta(1,4)*Dval(dd001,Di2) + 
     &      zeta(3,4)*Dval(dd002,Di4) + 
     &      zeta(4,4)*Dval(dd002,Di5) + 
     &      zeta(1,2)*Dval(dd003,Di2) + 
     &      zeta(2,2)*Dval(dd003,Di3) + 
     &      zeta(2,3)*Dval(dd003,Di4) - 
     &      (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd001,Di1) - 
     &      (zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       Dval(dd003,Di1))
	E(ee33) = -(eta(2)*Dval(dd22,Di2)) - 
     &   eta(3)*Dval(dd22,Di3) - eta(5)*Dval(dd33,Di5) - 
     &   eta(1)*Dval(dd22,Di1) + 
     &   4*zeta(1,3)*Dval(dd002,Di2) + 
     &   4*zeta(2,3)*Dval(dd002,Di3) + 
     &   4*zeta(3,4)*Dval(dd003,Di5) - 
     &   4*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd002,Di1)
	E(ee34) = -(eta(2)*Dval(dd23,Di2)) - 
     &   eta(3)*Dval(dd23,Di3) - eta(1)*Dval(dd23,Di1) + 
     &   2*(zeta(1,4)*Dval(dd002,Di2) + 
     &      zeta(2,4)*Dval(dd002,Di3) + 
     &      zeta(1,3)*Dval(dd003,Di2) + 
     &      zeta(2,3)*Dval(dd003,Di3) + 
     &      zeta(3,3)*Dval(dd003,Di4) + 
     &      zeta(4,4)*Dval(dd003,Di5) - 
     &      (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd002,Di1) - 
     &      (zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd003,Di1))
	E(ee44) = -(eta(2)*Dval(dd33,Di2)) - 
     &   eta(3)*Dval(dd33,Di3) - eta(4)*Dval(dd33,Di4) - 
     &   eta(1)*Dval(dd33,Di1) + 
     &   4*zeta(1,4)*Dval(dd003,Di2) + 
     &   4*zeta(2,4)*Dval(dd003,Di3) + 
     &   4*zeta(3,4)*Dval(dd003,Di4) - 
     &   4*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd003,Di1)

	E(ee001) = dabbr3*eta(1) - eta(3)*Dval(dd001,Di3) - 
     &   eta(4)*Dval(dd001,Di4) - eta(5)*Dval(dd001,Di5) + 
     &   2*(zeta(1,1)*(Dval(dd0000,Di2) - del) + 
     &      zeta(1,2)*(Dval(dd0000,Di3) - del) + 
     &      zeta(1,3)*(Dval(dd0000,Di4) - del) + 
     &      zeta(1,4)*(Dval(dd0000,Di5) - del) - 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,3) + zeta(1,4))*
     &       (Dval(dd0000,Di1) - del))
	E(ee002) = -(eta(2)*Dval(dd001,Di2)) - 
     &   eta(4)*Dval(dd002,Di4) - eta(5)*Dval(dd002,Di5) - 
     &   eta(1)*Dval(dd001,Di1) + 
     &   2*zeta(1,2)*(Dval(dd0000,Di2) - del) + 
     &   2*zeta(2,2)*(Dval(dd0000,Di3) - del) + 
     &   2*zeta(2,3)*(Dval(dd0000,Di4) - del) + 
     &   2*zeta(2,4)*(Dval(dd0000,Di5) - del) - 
     &   2*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    (Dval(dd0000,Di1) - del)
	E(ee003) = -(eta(2)*Dval(dd002,Di2)) - 
     &   eta(3)*Dval(dd002,Di3) - eta(5)*Dval(dd003,Di5) - 
     &   eta(1)*Dval(dd002,Di1) + 
     &   2*zeta(1,3)*(Dval(dd0000,Di2) - del) + 
     &   2*zeta(2,3)*(Dval(dd0000,Di3) - del) + 
     &   2*zeta(3,3)*(Dval(dd0000,Di4) - del) + 
     &   2*zeta(3,4)*(Dval(dd0000,Di5) - del) - 
     &   2*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    (Dval(dd0000,Di1) - del)
	E(ee004) = -(eta(2)*Dval(dd003,Di2)) - 
     &   eta(3)*Dval(dd003,Di3) - eta(4)*Dval(dd003,Di4) - 
     &   eta(1)*Dval(dd003,Di1) + 
     &   2*zeta(1,4)*(Dval(dd0000,Di2) - del) + 
     &   2*zeta(2,4)*(Dval(dd0000,Di3) - del) + 
     &   2*zeta(3,4)*(Dval(dd0000,Di4) - del) + 
     &   2*zeta(4,4)*(Dval(dd0000,Di5) - del) - 
     &   2*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    (Dval(dd0000,Di1) - del)
	E(ee111) = -6*dabbr11*
     &    (zeta(1,1) + zeta(1,2) + zeta(1,3) + zeta(1,4)) - 
     &   eta(3)*Dval(dd111,Di3) - eta(4)*Dval(dd111,Di4) - 
     &   eta(5)*Dval(dd111,Di5) + 
     &   eta(1)*(3*dabbr10 + Dval(dd0,Di1) + 
     &      3*Dval(dd1,Di1) + 3*Dval(dd2,Di1) + 
     &      3*Dval(dd3,Di1) + 3*Dval(dd11,Di1) + 
     &      6*Dval(dd12,Di1) + 6*Dval(dd13,Di1) + 
     &      3*Dval(dd22,Di1) + 6*Dval(dd23,Di1) + 
     &      3*Dval(dd33,Di1) + Dval(dd111,Di1) + 
     &      3*Dval(dd112,Di1) + 3*Dval(dd113,Di1) + 
     &      3*Dval(dd122,Di1) + 6*Dval(dd123,Di1) + 
     &      3*Dval(dd133,Di1) + Dval(dd222,Di1) + 
     &      Dval(dd333,Di1)) + 
     &   6*zeta(1,2)*Dval(dd0011,Di3) + 
     &   6*zeta(1,3)*Dval(dd0011,Di4) + 
     &   6*zeta(1,4)*Dval(dd0011,Di5)
	E(ee112) = -(dabbr12*eta(1)) - 
     &   2*dabbr14*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &      zeta(2,4)) - eta(4)*Dval(dd112,Di4) - 
     &   eta(5)*Dval(dd112,Di5) + 
     &   2*(2*dabbr13*(zeta(1,1) + zeta(1,3) + zeta(1,4) - 
     &         zeta(2,2) - zeta(2,3) - zeta(2,4)) + 
     &      zeta(2,2)*Dval(dd0011,Di3) + 
     &      zeta(2,3)*Dval(dd0011,Di4) + 
     &      zeta(2,4)*Dval(dd0011,Di5) + 
     &      2*zeta(1,3)*Dval(dd0012,Di4) + 
     &      2*zeta(1,4)*Dval(dd0012,Di5) + 
     &      (2*zeta(1,1) + zeta(1,2) + 2*zeta(1,3) + 2*zeta(1,4) - 
     &         zeta(2,2) - zeta(2,3) - zeta(2,4))*
     &       Dval(dd0011,Di1))
	E(ee113) = -(dabbr15*eta(1)) - 
     &   2*dabbr17*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &      zeta(3,4)) - eta(3)*Dval(dd112,Di3) - 
     &   eta(5)*Dval(dd113,Di5) + 
     &   2*(2*dabbr16*(zeta(1,1) + zeta(1,2) + zeta(1,4) - 
     &         zeta(2,3) - zeta(3,3) - zeta(3,4)) + 
     &      zeta(2,3)*Dval(dd0011,Di3) + 
     &      zeta(3,3)*Dval(dd0011,Di4) + 
     &      zeta(3,4)*Dval(dd0011,Di5) + 
     &      2*zeta(1,2)*Dval(dd0012,Di3) + 
     &      2*zeta(1,4)*Dval(dd0013,Di5) + 
     &      (2*zeta(1,1) + 2*zeta(1,2) + zeta(1,3) + 2*zeta(1,4) - 
     &         zeta(2,3) - zeta(3,3) - zeta(3,4))*
     &       Dval(dd0022,Di1))
	E(ee114) = -(dabbr18*eta(1)) - 
     &   2*dabbr19*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &      zeta(4,4)) - eta(3)*Dval(dd113,Di3) - 
     &   eta(4)*Dval(dd113,Di4) + 
     &   2*(2*dabbr20*(zeta(1,1) + zeta(1,2) + zeta(1,3) - 
     &         zeta(2,4) - zeta(3,4) - zeta(4,4)) + 
     &      zeta(2,4)*Dval(dd0011,Di3) + 
     &      zeta(3,4)*Dval(dd0011,Di4) + 
     &      zeta(4,4)*Dval(dd0011,Di5) + 
     &      2*zeta(1,2)*Dval(dd0013,Di3) + 
     &      2*zeta(1,3)*Dval(dd0013,Di4) + 
     &      (2*zeta(1,1) + 2*zeta(1,2) + 2*zeta(1,3) + zeta(1,4) - 
     &         zeta(2,4) - zeta(3,4) - zeta(4,4))*
     &       Dval(dd0033,Di1))
	E(ee122) = dabbr21*eta(1) - eta(4)*Dval(dd122,Di4) - 
     &   eta(5)*Dval(dd122,Di5) + 
     &   2*(2*dabbr13*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + zeta(1,1)*Dval(dd0011,Di2) + 
     &      2*zeta(2,3)*Dval(dd0012,Di4) + 
     &      2*zeta(2,4)*Dval(dd0012,Di5) + 
     &      zeta(1,3)*Dval(dd0022,Di4) + 
     &      zeta(1,4)*Dval(dd0022,Di5) - 
     &      (zeta(1,1) - zeta(1,2) + zeta(1,3) + zeta(1,4) - 
     &         2*(zeta(2,2) + zeta(2,3) + zeta(2,4)))*
     &       Dval(dd0011,Di1))
	E(ee123) = dabbr22*eta(1) - eta(5)*Dval(dd123,Di5) + 
     &   2*(dabbr24*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + 
     &      dabbr23*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + zeta(1,1)*Dval(dd0012,Di2) + 
     &      zeta(2,2)*Dval(dd0012,Di3) + 
     &      zeta(3,3)*Dval(dd0012,Di4) + 
     &      zeta(3,4)*Dval(dd0012,Di5) + 
     &      zeta(2,4)*Dval(dd0013,Di5) + 
     &      zeta(1,4)*Dval(dd0023,Di5) + 
     &      (-zeta(1,1) - zeta(1,4) + zeta(2,2) + 2*zeta(2,3) + 
     &         zeta(2,4) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd0012,Di1))
	E(ee124) = dabbr25*eta(1) - eta(4)*Dval(dd123,Di4) + 
     &   2*(dabbr27*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + 
     &      dabbr26*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + zeta(3,4)*Dval(dd0012,Di4) + 
     &      zeta(4,4)*Dval(dd0012,Di5) + 
     &      zeta(1,1)*Dval(dd0013,Di2) + 
     &      zeta(2,2)*Dval(dd0013,Di3) + 
     &      zeta(2,3)*Dval(dd0013,Di4) + 
     &      zeta(1,3)*Dval(dd0023,Di4) + 
     &      (-zeta(1,1) - zeta(1,3) + zeta(2,2) + zeta(2,3) + 
     &         2*zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd0013,Di1))
	E(ee133) = dabbr28*eta(1) - eta(3)*Dval(dd122,Di3) - 
     &   eta(5)*Dval(dd133,Di5) + 
     &   2*(2*dabbr16*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + 2*zeta(2,3)*Dval(dd0012,Di3) + 
     &      2*zeta(3,4)*Dval(dd0013,Di5) + 
     &      zeta(1,1)*Dval(dd0022,Di2) + 
     &      zeta(1,2)*Dval(dd0022,Di3) + 
     &      zeta(1,4)*Dval(dd0033,Di5) - 
     &      (zeta(1,1) + zeta(1,2) - zeta(1,3) + zeta(1,4) - 
     &         2*(zeta(2,3) + zeta(3,3) + zeta(3,4)))*
     &       Dval(dd0022,Di1))
	E(ee134) = dabbr29*eta(1) - eta(3)*Dval(dd123,Di3) + 
     &   2*(dabbr31*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + 
     &      dabbr30*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + zeta(2,4)*Dval(dd0012,Di3) + 
     &      zeta(2,3)*Dval(dd0013,Di3) + 
     &      zeta(3,3)*Dval(dd0013,Di4) + 
     &      zeta(4,4)*Dval(dd0013,Di5) + 
     &      zeta(1,1)*Dval(dd0023,Di2) + 
     &      zeta(1,2)*Dval(dd0023,Di3) + 
     &      (-zeta(1,1) - zeta(1,2) + zeta(2,3) + zeta(2,4) + 
     &         zeta(3,3) + 2*zeta(3,4) + zeta(4,4))*
     &       Dval(dd0023,Di1))
	E(ee144) = dabbr32*eta(1) - eta(3)*Dval(dd133,Di3) - 
     &   eta(4)*Dval(dd133,Di4) + 
     &   2*(2*dabbr20*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + 2*zeta(2,4)*Dval(dd0013,Di3) + 
     &      2*zeta(3,4)*Dval(dd0013,Di4) + 
     &      zeta(1,1)*Dval(dd0033,Di2) + 
     &      zeta(1,2)*Dval(dd0033,Di3) + 
     &      zeta(1,3)*Dval(dd0033,Di4) - 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,3) - zeta(1,4) - 
     &         2*(zeta(2,4) + zeta(3,4) + zeta(4,4)))*
     &       Dval(dd0033,Di1))
	E(ee222) = -(eta(2)*Dval(dd111,Di2)) - 
     &   eta(4)*Dval(dd222,Di4) - eta(5)*Dval(dd222,Di5) - 
     &   eta(1)*Dval(dd111,Di1) + 
     &   6*zeta(1,2)*Dval(dd0011,Di2) + 
     &   6*zeta(2,3)*Dval(dd0022,Di4) + 
     &   6*zeta(2,4)*Dval(dd0022,Di5) - 
     &   6*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd0011,Di1)
	E(ee223) = -(eta(2)*Dval(dd112,Di2)) - 
     &   eta(5)*Dval(dd223,Di5) - eta(1)*Dval(dd112,Di1) + 
     &   2*zeta(1,3)*Dval(dd0011,Di2) + 
     &   4*zeta(1,2)*Dval(dd0012,Di2) + 
     &   2*zeta(3,3)*Dval(dd0022,Di4) + 
     &   2*zeta(3,4)*Dval(dd0022,Di5) + 
     &   4*zeta(2,4)*Dval(dd0023,Di5) - 
     &   2*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd0011,Di1) - 
     &   4*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd0012,Di1)
	E(ee224) = -(eta(2)*Dval(dd113,Di2)) - 
     &   eta(4)*Dval(dd223,Di4) - eta(1)*Dval(dd113,Di1) + 
     &   2*zeta(1,4)*Dval(dd0011,Di2) + 
     &   4*zeta(1,2)*Dval(dd0013,Di2) + 
     &   2*zeta(3,4)*Dval(dd0022,Di4) + 
     &   2*zeta(4,4)*Dval(dd0022,Di5) + 
     &   4*zeta(2,3)*Dval(dd0023,Di4) - 
     &   2*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd0011,Di1) - 
     &   4*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd0013,Di1)
	E(ee233) = -(eta(2)*Dval(dd122,Di2)) - 
     &   eta(5)*Dval(dd233,Di5) - eta(1)*Dval(dd122,Di1) + 
     &   4*zeta(1,3)*Dval(dd0012,Di2) + 
     &   2*zeta(1,2)*Dval(dd0022,Di2) + 
     &   2*zeta(2,2)*Dval(dd0022,Di3) + 
     &   4*zeta(3,4)*Dval(dd0023,Di5) + 
     &   2*zeta(2,4)*Dval(dd0033,Di5) - 
     &   4*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd0012,Di1) - 
     &   2*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd0022,Di1)
	E(ee234) = -(eta(2)*Dval(dd123,Di2)) - 
     &   eta(1)*Dval(dd123,Di1) + 
     &   2*(zeta(1,4)*Dval(dd0012,Di2) + 
     &      zeta(1,3)*Dval(dd0013,Di2) + 
     &      zeta(1,2)*Dval(dd0023,Di2) + 
     &      zeta(2,2)*Dval(dd0023,Di3) + 
     &      zeta(3,3)*Dval(dd0023,Di4) + 
     &      zeta(4,4)*Dval(dd0023,Di5) - 
     &      (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd0012,Di1) - 
     &      (zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd0013,Di1) - 
     &      (zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       Dval(dd0023,Di1))
	E(ee244) = -(eta(2)*Dval(dd133,Di2)) - 
     &   eta(4)*Dval(dd233,Di4) - eta(1)*Dval(dd133,Di1) + 
     &   4*zeta(1,4)*Dval(dd0013,Di2) + 
     &   4*zeta(3,4)*Dval(dd0023,Di4) + 
     &   2*zeta(1,2)*Dval(dd0033,Di2) + 
     &   2*zeta(2,2)*Dval(dd0033,Di3) + 
     &   2*zeta(2,3)*Dval(dd0033,Di4) - 
     &   4*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd0013,Di1) - 
     &   2*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd0033,Di1)
	E(ee333) = -(eta(2)*Dval(dd222,Di2)) - 
     &   eta(3)*Dval(dd222,Di3) - eta(5)*Dval(dd333,Di5) - 
     &   eta(1)*Dval(dd222,Di1) + 
     &   6*zeta(1,3)*Dval(dd0022,Di2) + 
     &   6*zeta(2,3)*Dval(dd0022,Di3) + 
     &   6*zeta(3,4)*Dval(dd0033,Di5) - 
     &   6*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd0022,Di1)
	E(ee334) = -(eta(2)*Dval(dd223,Di2)) - 
     &   eta(3)*Dval(dd223,Di3) - eta(1)*Dval(dd223,Di1) + 
     &   2*zeta(1,4)*Dval(dd0022,Di2) + 
     &   2*zeta(2,4)*Dval(dd0022,Di3) + 
     &   4*zeta(1,3)*Dval(dd0023,Di2) + 
     &   4*zeta(2,3)*Dval(dd0023,Di3) + 
     &   2*zeta(4,4)*Dval(dd0033,Di5) - 
     &   2*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd0022,Di1) - 
     &   4*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd0023,Di1)
	E(ee344) = -(eta(2)*Dval(dd233,Di2)) - 
     &   eta(3)*Dval(dd233,Di3) - eta(1)*Dval(dd233,Di1) + 
     &   4*zeta(1,4)*Dval(dd0023,Di2) + 
     &   4*zeta(2,4)*Dval(dd0023,Di3) + 
     &   2*zeta(1,3)*Dval(dd0033,Di2) + 
     &   2*zeta(2,3)*Dval(dd0033,Di3) + 
     &   2*zeta(3,3)*Dval(dd0033,Di4) - 
     &   4*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd0023,Di1) - 
     &   2*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd0033,Di1)
	E(ee444) = -(eta(2)*Dval(dd333,Di2)) - 
     &   eta(3)*Dval(dd333,Di3) - eta(4)*Dval(dd333,Di4) - 
     &   eta(1)*Dval(dd333,Di1) + 
     &   6*zeta(1,4)*Dval(dd0033,Di2) + 
     &   6*zeta(2,4)*Dval(dd0033,Di3) + 
     &   6*zeta(3,4)*Dval(dd0033,Di4) - 
     &   6*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd0033,Di1)

	E(ee0000) = (-(detZ/detY) - 
     &     48*(eta(2)*(Dval(dd0000,Di2) - del) + 
     &        eta(3)*(Dval(dd0000,Di3) - del) + 
     &        eta(4)*(Dval(dd0000,Di4) - del) + 
     &        eta(5)*(Dval(dd0000,Di5) - del) + 
     &        eta(1)*(Dval(dd0000,Di1) - del)))/48D0
	E(ee0011) = -(dabbr11*eta(1)) - 
     &   eta(3)*Dval(dd0011,Di3) - 
     &   eta(4)*Dval(dd0011,Di4) - 
     &   eta(5)*Dval(dd0011,Di5) + 
     &   4*(dabbr33*(zeta(1,1) + zeta(1,2) + zeta(1,3) + 
     &         zeta(1,4)) + 
     &      zeta(1,2)*(Dval(dd00001,Di3) + del4) + 
     &      zeta(1,3)*(Dval(dd00001,Di4) + del4) + 
     &      zeta(1,4)*(Dval(dd00001,Di5) + del4))
	E(ee0012) = dabbr34*eta(1) - 
     &   eta(4)*Dval(dd0012,Di4) - 
     &   eta(5)*Dval(dd0012,Di5) + 
     &   2*(dabbr35*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + 
     &      zeta(1,1)*(Dval(dd00001,Di2) + del4) + 
     &      zeta(2,2)*(Dval(dd00001,Di3) + del4) + 
     &      zeta(2,3)*(Dval(dd00001,Di4) + del4) + 
     &      zeta(2,4)*(Dval(dd00001,Di5) + del4) + 
     &      zeta(1,3)*(Dval(dd00002,Di4) + del4) + 
     &      zeta(1,4)*(Dval(dd00002,Di5) + del4) - 
     &      (zeta(1,1) + zeta(1,3) + zeta(1,4) - zeta(2,2) - 
     &         zeta(2,3) - zeta(2,4))*
     &       (Dval(dd00001,Di1) + del4))
	E(ee0013) = dabbr36*eta(1) - 
     &   eta(3)*Dval(dd0012,Di3) - 
     &   eta(5)*Dval(dd0013,Di5) + 
     &   2*(dabbr37*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + 
     &      zeta(2,3)*(Dval(dd00001,Di3) + del4) + 
     &      zeta(3,3)*(Dval(dd00001,Di4) + del4) + 
     &      zeta(3,4)*(Dval(dd00001,Di5) + del4) + 
     &      zeta(1,1)*(Dval(dd00002,Di2) + del4) + 
     &      zeta(1,2)*(Dval(dd00002,Di3) + del4) + 
     &      zeta(1,4)*(Dval(dd00003,Di5) + del4) - 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,4) - zeta(2,3) - 
     &         zeta(3,3) - zeta(3,4))*
     &       (Dval(dd00002,Di1) + del4))
	E(ee0014) = dabbr38*eta(1) - 
     &   eta(3)*Dval(dd0013,Di3) - 
     &   eta(4)*Dval(dd0013,Di4) + 
     &   2*(dabbr39*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + 
     &      zeta(2,4)*(Dval(dd00001,Di3) + del4) + 
     &      zeta(3,4)*(Dval(dd00001,Di4) + del4) + 
     &      zeta(4,4)*(Dval(dd00001,Di5) + del4) + 
     &      zeta(1,1)*(Dval(dd00003,Di2) + del4) + 
     &      zeta(1,2)*(Dval(dd00003,Di3) + del4) + 
     &      zeta(1,3)*(Dval(dd00003,Di4) + del4) - 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,3) - zeta(2,4) - 
     &         zeta(3,4) - zeta(4,4))*
     &       (Dval(dd00003,Di1) + del4))
	E(ee0022) = -(eta(2)*Dval(dd0011,Di2)) - 
     &   eta(4)*Dval(dd0022,Di4) - 
     &   eta(5)*Dval(dd0022,Di5) - 
     &   eta(1)*Dval(dd0011,Di1) + 
     &   4*zeta(1,2)*(Dval(dd00001,Di2) + del4) + 
     &   4*zeta(2,3)*(Dval(dd00002,Di4) + del4) + 
     &   4*zeta(2,4)*(Dval(dd00002,Di5) + del4) - 
     &   4*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    (Dval(dd00001,Di1) + del4)
	E(ee0023) = -(eta(2)*Dval(dd0012,Di2)) - 
     &   eta(5)*Dval(dd0023,Di5) - 
     &   eta(1)*Dval(dd0012,Di1) + 
     &   2*(zeta(1,3)*(Dval(dd00001,Di2) + del4) + 
     &      zeta(1,2)*(Dval(dd00002,Di2) + del4) + 
     &      zeta(2,2)*(Dval(dd00002,Di3) + del4) + 
     &      zeta(3,3)*(Dval(dd00002,Di4) + del4) + 
     &      zeta(3,4)*(Dval(dd00002,Di5) + del4) + 
     &      zeta(2,4)*(Dval(dd00003,Di5) + del4) - 
     &      (zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       (Dval(dd00001,Di1) + del4) - 
     &      (zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       (Dval(dd00002,Di1) + del4))
	E(ee0024) = -(eta(2)*Dval(dd0013,Di2)) - 
     &   eta(4)*Dval(dd0023,Di4) - 
     &   eta(1)*Dval(dd0013,Di1) + 
     &   2*(zeta(1,4)*(Dval(dd00001,Di2) + del4) + 
     &      zeta(3,4)*(Dval(dd00002,Di4) + del4) + 
     &      zeta(4,4)*(Dval(dd00002,Di5) + del4) + 
     &      zeta(1,2)*(Dval(dd00003,Di2) + del4) + 
     &      zeta(2,2)*(Dval(dd00003,Di3) + del4) + 
     &      zeta(2,3)*(Dval(dd00003,Di4) + del4) - 
     &      (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       (Dval(dd00001,Di1) + del4) - 
     &      (zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       (Dval(dd00003,Di1) + del4))
	E(ee0033) = -(eta(2)*Dval(dd0022,Di2)) - 
     &   eta(3)*Dval(dd0022,Di3) - 
     &   eta(5)*Dval(dd0033,Di5) - 
     &   eta(1)*Dval(dd0022,Di1) + 
     &   4*zeta(1,3)*(Dval(dd00002,Di2) + del4) + 
     &   4*zeta(2,3)*(Dval(dd00002,Di3) + del4) + 
     &   4*zeta(3,4)*(Dval(dd00003,Di5) + del4) - 
     &   4*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    (Dval(dd00002,Di1) + del4)
	E(ee0034) = -(eta(2)*Dval(dd0023,Di2)) - 
     &   eta(3)*Dval(dd0023,Di3) - 
     &   eta(1)*Dval(dd0023,Di1) + 
     &   2*(zeta(1,4)*(Dval(dd00002,Di2) + del4) + 
     &      zeta(2,4)*(Dval(dd00002,Di3) + del4) + 
     &      zeta(1,3)*(Dval(dd00003,Di2) + del4) + 
     &      zeta(2,3)*(Dval(dd00003,Di3) + del4) + 
     &      zeta(3,3)*(Dval(dd00003,Di4) + del4) + 
     &      zeta(4,4)*(Dval(dd00003,Di5) + del4) - 
     &      (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       (Dval(dd00002,Di1) + del4) - 
     &      (zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       (Dval(dd00003,Di1) + del4))
	E(ee0044) = -(eta(2)*Dval(dd0033,Di2)) - 
     &   eta(3)*Dval(dd0033,Di3) - 
     &   eta(4)*Dval(dd0033,Di4) - 
     &   eta(1)*Dval(dd0033,Di1) + 
     &   4*zeta(1,4)*(Dval(dd00003,Di2) + del4) + 
     &   4*zeta(2,4)*(Dval(dd00003,Di3) + del4) + 
     &   4*zeta(3,4)*(Dval(dd00003,Di4) + del4) - 
     &   4*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    (Dval(dd00003,Di1) + del4)
	E(ee1111) = -(dabbr40*eta(1)) - 
     &   eta(3)*Dval(dd1111,Di3) - 
     &   eta(4)*Dval(dd1111,Di4) - 
     &   eta(5)*Dval(dd1111,Di5) + 
     &   8*zeta(1,2)*Dval(dd00111,Di3) + 
     &   8*zeta(1,3)*Dval(dd00111,Di4) + 
     &   8*zeta(1,4)*Dval(dd00111,Di5) + 
     &   8*(zeta(1,1) + zeta(1,2) + zeta(1,3) + zeta(1,4))*
     &    (3*dabbr41 + Dval(dd00,Di1) + 
     &      3*Dval(dd001,Di1) + 3*Dval(dd002,Di1) + 
     &      3*Dval(dd003,Di1) + 3*Dval(dd0011,Di1) + 
     &      6*Dval(dd0012,Di1) + 6*Dval(dd0013,Di1) + 
     &      3*Dval(dd0022,Di1) + 6*Dval(dd0023,Di1) + 
     &      3*Dval(dd0033,Di1) + Dval(dd00111,Di1) + 
     &      3*Dval(dd00112,Di1) + 3*Dval(dd00113,Di1) + 
     &      3*Dval(dd00122,Di1) + 6*Dval(dd00123,Di1) + 
     &      3*Dval(dd00133,Di1) + Dval(dd00222,Di1) + 
     &      Dval(dd00333,Di1))
	E(ee1112) = -6*dabbr44*
     &    (zeta(1,1) + zeta(1,3) + zeta(1,4) - zeta(2,2) - 
     &      zeta(2,3) - zeta(2,4)) - 
     &   6*dabbr43*(2*zeta(1,1) + zeta(1,2) + 2*zeta(1,3) + 
     &      2*zeta(1,4) - zeta(2,2) - zeta(2,3) - zeta(2,4)) - 
     &   eta(4)*Dval(dd1112,Di4) - 
     &   eta(5)*Dval(dd1112,Di5) + 
     &   eta(1)*(3*dabbr42 + Dval(dd1,Di1) + 
     &      3*Dval(dd11,Di1) + 3*Dval(dd12,Di1) + 
     &      3*Dval(dd13,Di1) + 3*Dval(dd111,Di1) + 
     &      6*Dval(dd112,Di1) + 6*Dval(dd113,Di1) + 
     &      3*Dval(dd122,Di1) + 6*Dval(dd123,Di1) + 
     &      3*Dval(dd133,Di1) + Dval(dd1111,Di1) + 
     &      3*Dval(dd1112,Di1) + 3*Dval(dd1113,Di1) + 
     &      3*Dval(dd1122,Di1) + 6*Dval(dd1123,Di1) + 
     &      3*Dval(dd1133,Di1) + Dval(dd1222,Di1) + 
     &      Dval(dd1333,Di1)) + 
     &   2*(zeta(2,2)*Dval(dd00111,Di3) + 
     &      zeta(2,3)*Dval(dd00111,Di4) + 
     &      zeta(2,4)*Dval(dd00111,Di5) + 
     &      3*zeta(1,3)*Dval(dd00112,Di4) + 
     &      3*zeta(1,4)*Dval(dd00112,Di5) + 
     &      (-3*zeta(1,1) - 2*zeta(1,2) - 3*zeta(1,3) - 
     &         3*zeta(1,4) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       Dval(dd00111,Di1)) + 
     &   2*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    (3*dabbr41 + Dval(dd00,Di1) + 
     &      3*Dval(dd002,Di1) + 3*Dval(dd003,Di1) + 
     &      3*Dval(dd0022,Di1) + 6*Dval(dd0023,Di1) + 
     &      3*Dval(dd0033,Di1) + Dval(dd00222,Di1) + 
     &      Dval(dd00333,Di1))
	E(ee1113) = -6*dabbr47*
     &    (zeta(1,1) + zeta(1,2) + zeta(1,4) - zeta(2,3) - 
     &      zeta(3,3) - zeta(3,4)) - 
     &   6*dabbr46*(2*zeta(1,1) + 2*zeta(1,2) + zeta(1,3) + 
     &      2*zeta(1,4) - zeta(2,3) - zeta(3,3) - zeta(3,4)) - 
     &   eta(3)*Dval(dd1112,Di3) - 
     &   eta(5)*Dval(dd1113,Di5) + 
     &   eta(1)*(3*dabbr45 + Dval(dd2,Di1) + 
     &      3*Dval(dd12,Di1) + 3*Dval(dd22,Di1) + 
     &      3*Dval(dd23,Di1) + 3*Dval(dd112,Di1) + 
     &      6*Dval(dd122,Di1) + 6*Dval(dd123,Di1) + 
     &      3*Dval(dd222,Di1) + 6*Dval(dd223,Di1) + 
     &      3*Dval(dd233,Di1) + Dval(dd1112,Di1) + 
     &      3*Dval(dd1122,Di1) + 3*Dval(dd1123,Di1) + 
     &      3*Dval(dd1222,Di1) + 6*Dval(dd1223,Di1) + 
     &      3*Dval(dd1233,Di1) + Dval(dd2222,Di1) + 
     &      Dval(dd2333,Di1)) + 
     &   2*(zeta(2,3)*Dval(dd00111,Di3) + 
     &      zeta(3,3)*Dval(dd00111,Di4) + 
     &      zeta(3,4)*Dval(dd00111,Di5) + 
     &      3*zeta(1,2)*Dval(dd00112,Di3) + 
     &      3*zeta(1,4)*Dval(dd00113,Di5) + 
     &      (-3*zeta(1,1) - 3*zeta(1,2) - 2*zeta(1,3) - 
     &         3*zeta(1,4) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd00222,Di1)) + 
     &   2*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    (3*dabbr48 + Dval(dd00,Di1) + 
     &      3*Dval(dd001,Di1) + 3*Dval(dd003,Di1) + 
     &      3*Dval(dd0011,Di1) + 6*Dval(dd0013,Di1) + 
     &      3*Dval(dd0033,Di1) + Dval(dd00111,Di1) + 
     &      Dval(dd00333,Di1))
	E(ee1114) = -6*dabbr51*
     &    (zeta(1,1) + zeta(1,2) + zeta(1,3) - zeta(2,4) - 
     &      zeta(3,4) - zeta(4,4)) - 
     &   6*dabbr52*(2*zeta(1,1) + 2*zeta(1,2) + 2*zeta(1,3) + 
     &      zeta(1,4) - zeta(2,4) - zeta(3,4) - zeta(4,4)) - 
     &   eta(3)*Dval(dd1113,Di3) - 
     &   eta(4)*Dval(dd1113,Di4) + 
     &   eta(1)*(3*dabbr49 + Dval(dd3,Di1) + 
     &      3*Dval(dd13,Di1) + 3*Dval(dd23,Di1) + 
     &      3*Dval(dd33,Di1) + 3*Dval(dd113,Di1) + 
     &      6*Dval(dd123,Di1) + 6*Dval(dd133,Di1) + 
     &      3*Dval(dd223,Di1) + 6*Dval(dd233,Di1) + 
     &      3*Dval(dd333,Di1) + Dval(dd1113,Di1) + 
     &      3*Dval(dd1123,Di1) + 3*Dval(dd1133,Di1) + 
     &      3*Dval(dd1223,Di1) + 6*Dval(dd1233,Di1) + 
     &      3*Dval(dd1333,Di1) + Dval(dd2223,Di1) + 
     &      Dval(dd3333,Di1)) + 
     &   2*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    (3*dabbr50 + Dval(dd00,Di1) + 
     &      3*Dval(dd001,Di1) + 3*Dval(dd002,Di1) + 
     &      3*Dval(dd0011,Di1) + 6*Dval(dd0012,Di1) + 
     &      3*Dval(dd0022,Di1) + Dval(dd00111,Di1) + 
     &      Dval(dd00222,Di1)) + 
     &   2*(zeta(2,4)*Dval(dd00111,Di3) + 
     &      zeta(3,4)*Dval(dd00111,Di4) + 
     &      zeta(4,4)*Dval(dd00111,Di5) + 
     &      3*zeta(1,2)*Dval(dd00113,Di3) + 
     &      3*zeta(1,3)*Dval(dd00113,Di4) + 
     &      (-3*zeta(1,1) - 3*zeta(1,2) - 3*zeta(1,3) - 
     &         2*zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd00333,Di1))
	E(ee1122) = -(dabbr53*eta(1)) - 
     &   4*dabbr44*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &      zeta(2,4)) - eta(4)*Dval(dd1122,Di4) - 
     &   eta(5)*Dval(dd1122,Di5) + 
     &   4*(-2*dabbr43*(zeta(2,2) + zeta(2,3) + zeta(2,4)) + 
     &      zeta(1,1)*Dval(dd0011,Di1) - 
     &      zeta(1,2)*Dval(dd0011,Di1) + 
     &      zeta(1,3)*Dval(dd0011,Di1) + 
     &      zeta(1,4)*Dval(dd0011,Di1) + 
     &      zeta(2,3)*Dval(dd00112,Di4) + 
     &      zeta(2,4)*Dval(dd00112,Di5) + 
     &      zeta(1,3)*Dval(dd00122,Di4) + 
     &      zeta(1,4)*Dval(dd00122,Di5) + 
     &      (zeta(1,1) + zeta(1,3) + zeta(1,4) - zeta(2,2) - 
     &         zeta(2,3) - zeta(2,4))*Dval(dd00111,Di1) + 
     &      zeta(1,1)*Dval(dd00112,Di1) - 
     &      zeta(1,2)*Dval(dd00112,Di1) + 
     &      zeta(1,3)*Dval(dd00112,Di1) + 
     &      zeta(1,4)*Dval(dd00112,Di1) + 
     &      (zeta(1,1) - zeta(1,2) + zeta(1,3) + zeta(1,4))*
     &       Dval(dd00113,Di1))
	E(ee1123) = -(dabbr54*eta(1)) - 
     &   2*dabbr57*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &      zeta(2,4)) - 2*dabbr56*
     &    (zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4)) - 
     &   eta(5)*Dval(dd1123,Di5) + 
     &   2*(2*dabbr55*(zeta(1,1) + zeta(1,4) - zeta(2,2) - 
     &         2*zeta(2,3) - zeta(2,4) - zeta(3,3) - zeta(3,4)) + 
     &      zeta(2,2)*Dval(dd00112,Di3) + 
     &      zeta(3,3)*Dval(dd00112,Di4) + 
     &      zeta(3,4)*Dval(dd00112,Di5) + 
     &      zeta(2,4)*Dval(dd00113,Di5) + 
     &      2*zeta(1,4)*Dval(dd00123,Di5) + 
     &      (2*zeta(1,1) + zeta(1,2) + 2*zeta(1,4) - zeta(2,2) - 
     &         3*zeta(2,3) - zeta(2,4) - 2*zeta(3,3) - 2*zeta(3,4))
     &        *Dval(dd00112,Di1) + 
     &      (2*zeta(1,1) + zeta(1,3) + 2*zeta(1,4) - 2*zeta(2,2) - 
     &         3*zeta(2,3) - 2*zeta(2,4) - zeta(3,3) - zeta(3,4))*
     &       Dval(dd00122,Di1))
	E(ee1124) = -(dabbr58*eta(1)) - 
     &   2*dabbr61*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &      zeta(2,4)) - 2*dabbr59*
     &    (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4)) - 
     &   eta(4)*Dval(dd1123,Di4) + 
     &   2*(2*dabbr60*(zeta(1,1) + zeta(1,3) - zeta(2,2) - 
     &         zeta(2,3) - 2*zeta(2,4) - zeta(3,4) - zeta(4,4)) + 
     &      zeta(3,4)*Dval(dd00112,Di4) + 
     &      zeta(4,4)*Dval(dd00112,Di5) + 
     &      zeta(2,2)*Dval(dd00113,Di3) + 
     &      zeta(2,3)*Dval(dd00113,Di4) + 
     &      2*zeta(1,3)*Dval(dd00123,Di4) + 
     &      (2*zeta(1,1) + zeta(1,2) + 2*zeta(1,3) - zeta(2,2) - 
     &         zeta(2,3) - 3*zeta(2,4) - 2*zeta(3,4) - 2*zeta(4,4))
     &        *Dval(dd00113,Di1) + 
     &      (2*zeta(1,1) + 2*zeta(1,3) + zeta(1,4) - 2*zeta(2,2) - 
     &         2*zeta(2,3) - 3*zeta(2,4) - zeta(3,4) - zeta(4,4))*
     &       Dval(dd00133,Di1))
	E(ee1133) = -(dabbr62*eta(1)) - 
     &   4*dabbr47*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &      zeta(3,4)) - eta(3)*Dval(dd1122,Di3) - 
     &   eta(5)*Dval(dd1133,Di5) + 
     &   4*(-2*dabbr46*(zeta(2,3) + zeta(3,3) + zeta(3,4)) + 
     &      zeta(1,1)*Dval(dd0022,Di1) + 
     &      zeta(1,2)*Dval(dd0022,Di1) - 
     &      zeta(1,3)*Dval(dd0022,Di1) + 
     &      zeta(1,4)*Dval(dd0022,Di1) + 
     &      zeta(2,3)*Dval(dd00112,Di3) + 
     &      zeta(3,4)*Dval(dd00113,Di5) + 
     &      zeta(1,2)*Dval(dd00122,Di3) + 
     &      zeta(1,4)*Dval(dd00133,Di5) + 
     &      zeta(1,1)*Dval(dd00122,Di1) + 
     &      zeta(1,2)*Dval(dd00122,Di1) - 
     &      zeta(1,3)*Dval(dd00122,Di1) + 
     &      zeta(1,4)*Dval(dd00122,Di1) + 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,4) - zeta(2,3) - 
     &         zeta(3,3) - zeta(3,4))*Dval(dd00222,Di1) + 
     &      (zeta(1,1) + zeta(1,2) - zeta(1,3) + zeta(1,4))*
     &       Dval(dd00223,Di1))
	E(ee1134) = -(dabbr63*eta(1)) - 
     &   2*dabbr66*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &      zeta(3,4)) - 2*dabbr64*
     &    (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4)) - 
     &   eta(3)*Dval(dd1123,Di3) + 
     &   2*(2*dabbr65*(zeta(1,1) + zeta(1,2) - zeta(2,3) - 
     &         zeta(2,4) - zeta(3,3) - 2*zeta(3,4) - zeta(4,4)) + 
     &      zeta(2,4)*Dval(dd00112,Di3) + 
     &      zeta(2,3)*Dval(dd00113,Di3) + 
     &      zeta(3,3)*Dval(dd00113,Di4) + 
     &      zeta(4,4)*Dval(dd00113,Di5) + 
     &      2*zeta(1,2)*Dval(dd00123,Di3) + 
     &      (2*zeta(1,1) + 2*zeta(1,2) + zeta(1,3) - zeta(2,3) - 
     &         2*zeta(2,4) - zeta(3,3) - 3*zeta(3,4) - 2*zeta(4,4))
     &        *Dval(dd00223,Di1) + 
     &      (2*zeta(1,1) + 2*zeta(1,2) + zeta(1,4) - 2*zeta(2,3) - 
     &         zeta(2,4) - 2*zeta(3,3) - 3*zeta(3,4) - zeta(4,4))*
     &       Dval(dd00233,Di1))
	E(ee1144) = -(dabbr67*eta(1)) - 
     &   4*dabbr51*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &      zeta(4,4)) - eta(3)*Dval(dd1133,Di3) - 
     &   eta(4)*Dval(dd1133,Di4) + 
     &   4*(-2*dabbr52*(zeta(2,4) + zeta(3,4) + zeta(4,4)) + 
     &      zeta(1,1)*Dval(dd0033,Di1) + 
     &      zeta(1,2)*Dval(dd0033,Di1) + 
     &      zeta(1,3)*Dval(dd0033,Di1) - 
     &      zeta(1,4)*Dval(dd0033,Di1) + 
     &      zeta(2,4)*Dval(dd00113,Di3) + 
     &      zeta(3,4)*Dval(dd00113,Di4) + 
     &      zeta(1,2)*Dval(dd00133,Di3) + 
     &      zeta(1,3)*Dval(dd00133,Di4) + 
     &      zeta(1,1)*Dval(dd00133,Di1) + 
     &      zeta(1,2)*Dval(dd00133,Di1) + 
     &      zeta(1,3)*Dval(dd00133,Di1) - 
     &      zeta(1,4)*Dval(dd00133,Di1) + 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,3) - zeta(1,4))*
     &       Dval(dd00233,Di1) + 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,3) - zeta(2,4) - 
     &         zeta(3,4) - zeta(4,4))*Dval(dd00333,Di1))
	E(ee1222) = dabbr68*eta(1) - 
     &   eta(4)*Dval(dd1222,Di4) - 
     &   eta(5)*Dval(dd1222,Di5) + 
     &   2*(3*dabbr43*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + zeta(1,1)*Dval(dd00111,Di2) + 
     &      3*zeta(2,3)*Dval(dd00122,Di4) + 
     &      3*zeta(2,4)*Dval(dd00122,Di5) + 
     &      zeta(1,3)*Dval(dd00222,Di4) + 
     &      zeta(1,4)*Dval(dd00222,Di5) - 
     &      (zeta(1,1) - 2*zeta(1,2) + zeta(1,3) + zeta(1,4) - 
     &         3*(zeta(2,2) + zeta(2,3) + zeta(2,4)))*
     &       Dval(dd00111,Di1))
	E(ee1223) = dabbr69*eta(1) - 
     &   eta(5)*Dval(dd1223,Di5) + 
     &   2*(2*dabbr71*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + 
     &      dabbr70*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + zeta(1,1)*Dval(dd00112,Di2) + 
     &      zeta(3,3)*Dval(dd00122,Di4) + 
     &      zeta(3,4)*Dval(dd00122,Di5) + 
     &      2*zeta(2,4)*Dval(dd00123,Di5) + 
     &      zeta(1,4)*Dval(dd00223,Di5) + 
     &      (-zeta(1,1) + zeta(1,2) - zeta(1,4) + 2*zeta(2,2) + 
     &         3*zeta(2,3) + 2*zeta(2,4) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd00112,Di1))
	E(ee1224) = dabbr72*eta(1) - 
     &   eta(4)*Dval(dd1223,Di4) + 
     &   2*(2*dabbr74*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + 
     &      dabbr73*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + zeta(1,1)*Dval(dd00113,Di2) + 
     &      zeta(3,4)*Dval(dd00122,Di4) + 
     &      zeta(4,4)*Dval(dd00122,Di5) + 
     &      2*zeta(2,3)*Dval(dd00123,Di4) + 
     &      zeta(1,3)*Dval(dd00223,Di4) + 
     &      (-zeta(1,1) + zeta(1,2) - zeta(1,3) + 2*zeta(2,2) + 
     &         2*zeta(2,3) + 3*zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd00113,Di1))
	E(ee1233) = dabbr75*eta(1) - 
     &   eta(5)*Dval(dd1233,Di5) + 
     &   2*(dabbr77*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + 
     &      2*dabbr76*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + zeta(1,1)*Dval(dd00122,Di2) + 
     &      zeta(2,2)*Dval(dd00122,Di3) + 
     &      2*zeta(3,4)*Dval(dd00123,Di5) + 
     &      zeta(2,4)*Dval(dd00133,Di5) + 
     &      zeta(1,4)*Dval(dd00233,Di5) + 
     &      (-zeta(1,1) + zeta(1,3) - zeta(1,4) + zeta(2,2) + 
     &         3*zeta(2,3) + zeta(2,4) + 2*(zeta(3,3) + zeta(3,4)))
     &        *Dval(dd00122,Di1))
	E(ee1234) = dabbr78*eta(1) + 
     &   2*(dabbr81*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + 
     &      dabbr80*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + 
     &      dabbr79*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + zeta(1,1)*Dval(dd00123,Di2) + 
     &      zeta(2,2)*Dval(dd00123,Di3) + 
     &      zeta(3,3)*Dval(dd00123,Di4) + 
     &      zeta(4,4)*Dval(dd00123,Di5) + 
     &      (-zeta(1,1) + zeta(2,2) + 2*zeta(2,3) + 2*zeta(2,4) + 
     &         zeta(3,3) + 2*zeta(3,4) + zeta(4,4))*
     &       Dval(dd00123,Di1))
	E(ee1244) = dabbr82*eta(1) - 
     &   eta(4)*Dval(dd1233,Di4) + 
     &   2*(dabbr84*(zeta(1,2) + zeta(2,2) + zeta(2,3) + 
     &         zeta(2,4)) + 
     &      2*dabbr83*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + 2*zeta(3,4)*Dval(dd00123,Di4) + 
     &      zeta(1,1)*Dval(dd00133,Di2) + 
     &      zeta(2,2)*Dval(dd00133,Di3) + 
     &      zeta(2,3)*Dval(dd00133,Di4) + 
     &      zeta(1,3)*Dval(dd00233,Di4) + 
     &      (-zeta(1,1) - zeta(1,3) + zeta(1,4) + zeta(2,2) + 
     &         zeta(2,3) + 3*zeta(2,4) + 2*(zeta(3,4) + zeta(4,4)))
     &        *Dval(dd00133,Di1))
	E(ee1333) = dabbr85*eta(1) - 
     &   eta(3)*Dval(dd1222,Di3) - 
     &   eta(5)*Dval(dd1333,Di5) + 
     &   2*(3*dabbr46*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + 3*zeta(2,3)*Dval(dd00122,Di3) + 
     &      3*zeta(3,4)*Dval(dd00133,Di5) + 
     &      zeta(1,1)*Dval(dd00222,Di2) + 
     &      zeta(1,2)*Dval(dd00222,Di3) + 
     &      zeta(1,4)*Dval(dd00333,Di5) - 
     &      (zeta(1,1) + zeta(1,2) - 2*zeta(1,3) + zeta(1,4) - 
     &         3*(zeta(2,3) + zeta(3,3) + zeta(3,4)))*
     &       Dval(dd00222,Di1))
	E(ee1334) = dabbr86*eta(1) - 
     &   eta(3)*Dval(dd1223,Di3) + 
     &   2*(2*dabbr88*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + 
     &      dabbr87*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + zeta(2,4)*Dval(dd00122,Di3) + 
     &      2*zeta(2,3)*Dval(dd00123,Di3) + 
     &      zeta(4,4)*Dval(dd00133,Di5) + 
     &      zeta(1,1)*Dval(dd00223,Di2) + 
     &      zeta(1,2)*Dval(dd00223,Di3) + 
     &      (-zeta(1,1) - zeta(1,2) + zeta(1,3) + 2*zeta(2,3) + 
     &         zeta(2,4) + 2*zeta(3,3) + 3*zeta(3,4) + zeta(4,4))*
     &       Dval(dd00223,Di1))
	E(ee1344) = dabbr89*eta(1) - 
     &   eta(3)*Dval(dd1233,Di3) + 
     &   2*(dabbr91*(zeta(1,3) + zeta(2,3) + zeta(3,3) + 
     &         zeta(3,4)) + 
     &      2*dabbr90*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + 2*zeta(2,4)*Dval(dd00123,Di3) + 
     &      zeta(2,3)*Dval(dd00133,Di3) + 
     &      zeta(3,3)*Dval(dd00133,Di4) + 
     &      zeta(1,1)*Dval(dd00233,Di2) + 
     &      zeta(1,2)*Dval(dd00233,Di3) + 
     &      (-zeta(1,1) - zeta(1,2) + zeta(1,4) + zeta(2,3) + 
     &         2*zeta(2,4) + zeta(3,3) + 3*zeta(3,4) + 2*zeta(4,4))
     &        *Dval(dd00233,Di1))
	E(ee1444) = dabbr92*eta(1) - 
     &   eta(3)*Dval(dd1333,Di3) - 
     &   eta(4)*Dval(dd1333,Di4) + 
     &   2*(3*dabbr52*(zeta(1,4) + zeta(2,4) + zeta(3,4) + 
     &         zeta(4,4)) + 3*zeta(2,4)*Dval(dd00133,Di3) + 
     &      3*zeta(3,4)*Dval(dd00133,Di4) + 
     &      zeta(1,1)*Dval(dd00333,Di2) + 
     &      zeta(1,2)*Dval(dd00333,Di3) + 
     &      zeta(1,3)*Dval(dd00333,Di4) - 
     &      (zeta(1,1) + zeta(1,2) + zeta(1,3) - 2*zeta(1,4) - 
     &         3*(zeta(2,4) + zeta(3,4) + zeta(4,4)))*
     &       Dval(dd00333,Di1))
	E(ee2222) = -(eta(2)*Dval(dd1111,Di2)) - 
     &   eta(4)*Dval(dd2222,Di4) - 
     &   eta(5)*Dval(dd2222,Di5) - 
     &   eta(1)*Dval(dd1111,Di1) + 
     &   8*zeta(1,2)*Dval(dd00111,Di2) + 
     &   8*zeta(2,3)*Dval(dd00222,Di4) + 
     &   8*zeta(2,4)*Dval(dd00222,Di5) - 
     &   8*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd00111,Di1)
	E(ee2223) = -(eta(2)*Dval(dd1112,Di2)) - 
     &   eta(5)*Dval(dd2223,Di5) - 
     &   eta(1)*Dval(dd1112,Di1) + 
     &   2*zeta(1,3)*Dval(dd00111,Di2) + 
     &   6*zeta(1,2)*Dval(dd00112,Di2) + 
     &   2*zeta(3,3)*Dval(dd00222,Di4) + 
     &   2*zeta(3,4)*Dval(dd00222,Di5) + 
     &   6*zeta(2,4)*Dval(dd00223,Di5) - 
     &   2*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd00111,Di1) - 
     &   6*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd00112,Di1)
	E(ee2224) = -(eta(2)*Dval(dd1113,Di2)) - 
     &   eta(4)*Dval(dd2223,Di4) - 
     &   eta(1)*Dval(dd1113,Di1) + 
     &   2*zeta(1,4)*Dval(dd00111,Di2) + 
     &   6*zeta(1,2)*Dval(dd00113,Di2) + 
     &   2*zeta(3,4)*Dval(dd00222,Di4) + 
     &   2*zeta(4,4)*Dval(dd00222,Di5) + 
     &   6*zeta(2,3)*Dval(dd00223,Di4) - 
     &   2*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd00111,Di1) - 
     &   6*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd00113,Di1)
	E(ee2233) = -(eta(2)*Dval(dd1122,Di2)) - 
     &   eta(5)*Dval(dd2233,Di5) - 
     &   eta(1)*Dval(dd1122,Di1) + 
     &   4*(zeta(1,3)*Dval(dd00112,Di2) + 
     &      zeta(1,2)*Dval(dd00122,Di2) + 
     &      zeta(3,4)*Dval(dd00223,Di5) + 
     &      zeta(2,4)*Dval(dd00233,Di5) - 
     &      (zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd00112,Di1) - 
     &      (zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       Dval(dd00122,Di1))
	E(ee2234) = -(eta(2)*Dval(dd1123,Di2)) - 
     &   eta(1)*Dval(dd1123,Di1) + 
     &   2*(zeta(1,4)*Dval(dd00112,Di2) + 
     &      zeta(1,3)*Dval(dd00113,Di2) + 
     &      2*zeta(1,2)*Dval(dd00123,Di2) + 
     &      zeta(3,3)*Dval(dd00223,Di4) + 
     &      zeta(4,4)*Dval(dd00223,Di5) - 
     &      (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd00112,Di1) - 
     &      (zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd00113,Di1) - 
     &      2*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       Dval(dd00123,Di1))
	E(ee2244) = -(eta(2)*Dval(dd1133,Di2)) - 
     &   eta(4)*Dval(dd2233,Di4) - 
     &   eta(1)*Dval(dd1133,Di1) + 
     &   4*(zeta(1,4)*Dval(dd00113,Di2) + 
     &      zeta(1,2)*Dval(dd00133,Di2) + 
     &      zeta(3,4)*Dval(dd00223,Di4) + 
     &      zeta(2,3)*Dval(dd00233,Di4) - 
     &      (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd00113,Di1) - 
     &      (zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       Dval(dd00133,Di1))
	E(ee2333) = -(eta(2)*Dval(dd1222,Di2)) - 
     &   eta(5)*Dval(dd2333,Di5) - 
     &   eta(1)*Dval(dd1222,Di1) + 
     &   6*zeta(1,3)*Dval(dd00122,Di2) + 
     &   2*zeta(1,2)*Dval(dd00222,Di2) + 
     &   2*zeta(2,2)*Dval(dd00222,Di3) + 
     &   6*zeta(3,4)*Dval(dd00233,Di5) + 
     &   2*zeta(2,4)*Dval(dd00333,Di5) - 
     &   6*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd00122,Di1) - 
     &   2*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd00222,Di1)
	E(ee2334) = -(eta(2)*Dval(dd1223,Di2)) - 
     &   eta(1)*Dval(dd1223,Di1) + 
     &   2*(zeta(1,4)*Dval(dd00122,Di2) + 
     &      2*zeta(1,3)*Dval(dd00123,Di2) + 
     &      zeta(1,2)*Dval(dd00223,Di2) + 
     &      zeta(2,2)*Dval(dd00223,Di3) + 
     &      zeta(4,4)*Dval(dd00233,Di5) - 
     &      (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd00122,Di1) - 
     &      2*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd00123,Di1) - 
     &      (zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       Dval(dd00223,Di1))
	E(ee2344) = -(eta(2)*Dval(dd1233,Di2)) - 
     &   eta(1)*Dval(dd1233,Di1) + 
     &   2*(2*zeta(1,4)*Dval(dd00123,Di2) + 
     &      zeta(1,3)*Dval(dd00133,Di2) + 
     &      zeta(1,2)*Dval(dd00233,Di2) + 
     &      zeta(2,2)*Dval(dd00233,Di3) + 
     &      zeta(3,3)*Dval(dd00233,Di4) - 
     &      2*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd00123,Di1) - 
     &      (zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd00133,Di1) - 
     &      (zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &       Dval(dd00233,Di1))
	E(ee2444) = -(eta(2)*Dval(dd1333,Di2)) - 
     &   eta(4)*Dval(dd2333,Di4) - 
     &   eta(1)*Dval(dd1333,Di1) + 
     &   6*zeta(1,4)*Dval(dd00133,Di2) + 
     &   6*zeta(3,4)*Dval(dd00233,Di4) + 
     &   2*zeta(1,2)*Dval(dd00333,Di2) + 
     &   2*zeta(2,2)*Dval(dd00333,Di3) + 
     &   2*zeta(2,3)*Dval(dd00333,Di4) - 
     &   6*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd00133,Di1) - 
     &   2*(zeta(1,2) + zeta(2,2) + zeta(2,3) + zeta(2,4))*
     &    Dval(dd00333,Di1)
	E(ee3333) = -(eta(2)*Dval(dd2222,Di2)) - 
     &   eta(3)*Dval(dd2222,Di3) - 
     &   eta(5)*Dval(dd3333,Di5) - 
     &   eta(1)*Dval(dd2222,Di1) + 
     &   8*zeta(1,3)*Dval(dd00222,Di2) + 
     &   8*zeta(2,3)*Dval(dd00222,Di3) + 
     &   8*zeta(3,4)*Dval(dd00333,Di5) - 
     &   8*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd00222,Di1)
	E(ee3334) = -(eta(2)*Dval(dd2223,Di2)) - 
     &   eta(3)*Dval(dd2223,Di3) - 
     &   eta(1)*Dval(dd2223,Di1) + 
     &   2*zeta(1,4)*Dval(dd00222,Di2) + 
     &   2*zeta(2,4)*Dval(dd00222,Di3) + 
     &   6*zeta(1,3)*Dval(dd00223,Di2) + 
     &   6*zeta(2,3)*Dval(dd00223,Di3) + 
     &   2*zeta(4,4)*Dval(dd00333,Di5) - 
     &   2*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd00222,Di1) - 
     &   6*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd00223,Di1)
	E(ee3344) = -(eta(2)*Dval(dd2233,Di2)) - 
     &   eta(3)*Dval(dd2233,Di3) - 
     &   eta(1)*Dval(dd2233,Di1) + 
     &   4*(zeta(1,4)*Dval(dd00223,Di2) + 
     &      zeta(2,4)*Dval(dd00223,Di3) + 
     &      zeta(1,3)*Dval(dd00233,Di2) + 
     &      zeta(2,3)*Dval(dd00233,Di3) - 
     &      (zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &       Dval(dd00223,Di1) - 
     &      (zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &       Dval(dd00233,Di1))
	E(ee3444) = -(eta(2)*Dval(dd2333,Di2)) - 
     &   eta(3)*Dval(dd2333,Di3) - 
     &   eta(1)*Dval(dd2333,Di1) + 
     &   6*zeta(1,4)*Dval(dd00233,Di2) + 
     &   6*zeta(2,4)*Dval(dd00233,Di3) + 
     &   2*zeta(1,3)*Dval(dd00333,Di2) + 
     &   2*zeta(2,3)*Dval(dd00333,Di3) + 
     &   2*zeta(3,3)*Dval(dd00333,Di4) - 
     &   6*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd00233,Di1) - 
     &   2*(zeta(1,3) + zeta(2,3) + zeta(3,3) + zeta(3,4))*
     &    Dval(dd00333,Di1)
	E(ee4444) = -(eta(2)*Dval(dd3333,Di2)) - 
     &   eta(3)*Dval(dd3333,Di3) - 
     &   eta(4)*Dval(dd3333,Di4) - 
     &   eta(1)*Dval(dd3333,Di1) + 
     &   8*zeta(1,4)*Dval(dd00333,Di2) + 
     &   8*zeta(2,4)*Dval(dd00333,Di3) + 
     &   8*zeta(3,4)*Dval(dd00333,Di4) - 
     &   8*(zeta(1,4) + zeta(2,4) + zeta(3,4) + zeta(4,4))*
     &    Dval(dd00333,Di1)

	if( dump ) call XDumpCoeff(5, E)
	end

