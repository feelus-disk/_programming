* Eget.F
* retrieve the five-point tensor coefficients
* this file is part of LoopTools
* written by M. Rauch
* last modified 16 Nov 06 th

#include "defs.h"


	integer function XEget(p1, p2, p3, p4, p5, 
     &    p1p2, p2p3, p3p4, p4p5, p5p1, m1, m2, m3, m4, m5)
	implicit none
	DVAR p1, p2, p3, p4, p5
	DVAR p1p2, p2p3, p3p4, p4p5, p5p1
	DVAR m1, m2, m3, m4, m5

#include "lt.h"

	integer cachelookup
	external cachelookup, XEcoeff

	DVAR para(Pee)

	para(1) = p1
	para(2) = p2
	para(3) = p3
	para(4) = p4
	para(5) = p5
	para(6) = p1p2
	para(7) = p2p3
	para(8) = p3p4
	para(9) = p4p5
	para(10) = p5p1
	para(11) = m1
	para(12) = m2
	para(13) = m3
	para(14) = m4
	para(15) = m5

	XEget = cachelookup(para, Eval(1,0), XEcoeff, RC*Pee, Nee)
	end

************************************************************************

	double complex function XE0i(i, p1, p2, p3, p4, p5,
     &    p1p2, p2p3, p3p4, p4p5, p5p1, m1, m2, m3, m4, m5)
	implicit none
	integer i
	DVAR p1, p2, p3, p4, p5
	DVAR p1p2, p2p3, p3p4, p4p5, p5p1
	DVAR m1, m2, m3, m4, m5

#include "lt.h"

	integer XEget
	external XEget

	integer b

	b = XEget(p1, p2, p3, p4, p5,
     &    p1p2, p2p3, p3p4, p4p5, p5p1, m1, m2, m3, m4, m5)
	XE0i = Eval(i,b)
	end

************************************************************************

	subroutine XEcoeff(para, E, ldpara)
	implicit none
	integer ldpara
	DVAR para(ldpara,Pee)
	double complex E(Nee)

#include "lt.h"

	double complex Ecmp(Nee)

#ifdef COMPLEXPARA
	goto (1, 2, 3) ibits(versionkey, KeyEgetC, 2)
#else
	goto (1, 2, 3) ibits(versionkey, KeyEget, 2)
#endif

	call XEcoeffa(para, E, ldpara)
	return

1	call XEcoeffb(para, E, ldpara)
	return

2	call XEcheck(para, E, Ecmp, ldpara)
	return

3	call XEcheck(para, Ecmp, E, ldpara)
	end

************************************************************************

	subroutine XEcheck(para, Ea, Eb, ldpara)
	implicit none
	integer ldpara
	DVAR para(ldpara,Pee)
	double complex Ea(Nee), Eb(Nee)

#include "lt.h"

	double complex dE(Nee)
	integer i
	logical ini

	QVAR Y(4,4)
	common /XltEgram/ Y

	character*8 coeffname(Nee,2:5)
	common /ltcoeffnames/ coeffname

	call XEcoeffa(para, Ea, ldpara)
	call XEcoeffb(para, Eb, ldpara)

	dE(ee0) = 0
	dE(ee1) = 0
	dE(ee2) = 0
	dE(ee3) = 0
	dE(ee4) = 0
	dE(ee11) = -2*Ea(ee00)*Y(1,1)
	dE(ee12) = -2*Ea(ee00)*Y(1,2)
	dE(ee13) = -2*Ea(ee00)*Y(1,3)
	dE(ee14) = -2*Ea(ee00)*Y(1,4)
	dE(ee22) = -2*Ea(ee00)*Y(2,2)
	dE(ee23) = -2*Ea(ee00)*Y(2,3)
	dE(ee24) = -2*Ea(ee00)*Y(2,4)
	dE(ee33) = -2*Ea(ee00)*Y(3,3)
	dE(ee34) = -2*Ea(ee00)*Y(3,4)
	dE(ee44) = -2*Ea(ee00)*Y(4,4)
	dE(ee00) = Ea(ee00)
	dE(ee111) = -6*Ea(ee001)*Y(1,1)
	dE(ee112) = -2*(Ea(ee002)*Y(1,1) + Ea(ee001)*(Y(1,2) + Y(2,1)))
	dE(ee113) = -2*(Ea(ee003)*Y(1,1) + Ea(ee001)*(Y(1,3) + Y(3,1)))
	dE(ee114) = -2*(Ea(ee004)*Y(1,1) + Ea(ee001)*(Y(1,4) + Y(4,1)))
	dE(ee122) = -2*(Ea(ee002)*(Y(1,2) + Y(2,1)) + Ea(ee001)*Y(2,2))
        dE(ee123) = -2*(Ea(ee003)*Y(1,2) + Ea(ee001)*Y(2,3) + 
     &     Ea(ee002)*Y(3,1))
        dE(ee124) = -2*(Ea(ee004)*Y(1,2) + Ea(ee001)*Y(2,4) + 
     &     Ea(ee002)*Y(4,1))
	dE(ee133) = -2*(Ea(ee003)*(Y(1,3) + Y(3,1)) + Ea(ee001)*Y(3,3))
        dE(ee134) = -2*(Ea(ee004)*Y(1,3) + Ea(ee001)*Y(3,4) + 
     &     Ea(ee003)*Y(4,1))
	dE(ee144) = -2*(Ea(ee004)*(Y(1,4) + Y(4,1)) + Ea(ee001)*Y(4,4))
	dE(ee222) = -6*Ea(ee002)*Y(2,2)
	dE(ee223) = -2*(Ea(ee003)*Y(2,2) + Ea(ee002)*(Y(2,3) + Y(3,2)))
	dE(ee224) = -2*(Ea(ee004)*Y(2,2) + Ea(ee002)*(Y(2,4) + Y(4,2)))
	dE(ee233) = -2*(Ea(ee003)*(Y(2,3) + Y(3,2)) + Ea(ee002)*Y(3,3))
        dE(ee234) = -2*(Ea(ee004)*Y(2,3) + Ea(ee002)*Y(3,4) + 
     &     Ea(ee003)*Y(4,2))
	dE(ee244) = -2*(Ea(ee004)*(Y(2,4) + Y(4,2)) + Ea(ee002)*Y(4,4))
	dE(ee333) = -6*Ea(ee003)*Y(3,3)
	dE(ee334) = -2*(Ea(ee004)*Y(3,3) + Ea(ee003)*(Y(3,4) + Y(4,3)))
	dE(ee344) = -2*(Ea(ee004)*(Y(3,4) + Y(4,3)) + Ea(ee003)*Y(4,4))
	dE(ee444) = -6*Ea(ee004)*Y(4,4)
	dE(ee001) = Ea(ee001)
	dE(ee002) = Ea(ee002)
	dE(ee003) = Ea(ee003)
	dE(ee004) = Ea(ee004)
	dE(ee1111) = -12*Y(1,1)*(Ea(ee0011) + Ea(ee0000)*Y(1,1))
        dE(ee1112) = -6*(Ea(ee0012)*Y(1,1) + 
     &     (Ea(ee0011) + 2*Ea(ee0000)*Y(1,1))*Y(1,2))
        dE(ee1113) = -6*(Ea(ee0013)*Y(1,1) + 
     &     (Ea(ee0011) + 2*Ea(ee0000)*Y(1,1))*Y(1,3))
        dE(ee1114) = -6*(Ea(ee0014)*Y(1,1) + 
     &     (Ea(ee0011) + 2*Ea(ee0000)*Y(1,1))*Y(1,4))
        dE(ee1122) = -2*(Ea(ee0022)*Y(1,1) + 
     &     4*Y(1,2)*(Ea(ee0012) + Ea(ee0000)*Y(1,2)) + 
     &     (Ea(ee0011) + 2*Ea(ee0000)*Y(1,1))*Y(2,2))
        dE(ee1123) = -2*(Ea(ee0023)*Y(1,1) + 
     &     2*Ea(ee0013)*Y(1,2) + 
     &     2*(Ea(ee0012) + 2*Ea(ee0000)*Y(1,2))*Y(1,3) + 
     &     (Ea(ee0011) + 2*Ea(ee0000)*Y(1,1))*Y(2,3))
        dE(ee1124) = -2*(Ea(ee0024)*Y(1,1) + 
     &     2*Ea(ee0014)*Y(1,2) + 
     &     2*(Ea(ee0012) + 2*Ea(ee0000)*Y(1,2))*Y(1,4) + 
     &     (Ea(ee0011) + 2*Ea(ee0000)*Y(1,1))*Y(2,4))
        dE(ee1133) = -2*(Ea(ee0033)*Y(1,1) + 
     &     4*Y(1,3)*(Ea(ee0013) + Ea(ee0000)*Y(1,3)) + 
     &     (Ea(ee0011) + 2*Ea(ee0000)*Y(1,1))*Y(3,3))
        dE(ee1134) = -2*(Ea(ee0034)*Y(1,1) + 
     &     2*Ea(ee0014)*Y(1,3) + 
     &     2*(Ea(ee0013) + 2*Ea(ee0000)*Y(1,3))*Y(1,4) + 
     &     (Ea(ee0011) + 2*Ea(ee0000)*Y(1,1))*Y(3,4))
        dE(ee1144) = -2*(Ea(ee0044)*Y(1,1) + 
     &     4*Y(1,4)*(Ea(ee0014) + Ea(ee0000)*Y(1,4)) + 
     &     (Ea(ee0011) + 2*Ea(ee0000)*Y(1,1))*Y(4,4))
        dE(ee1222) = -6*(Ea(ee0022)*Y(1,2) + 
     &     (Ea(ee0012) + 2*Ea(ee0000)*Y(1,2))*Y(2,2))
        dE(ee1223) = -2*(2*Ea(ee0023)*Y(1,2) + 
     &     Ea(ee0022)*Y(1,3) + 
     &     (Ea(ee0013) + 2*Ea(ee0000)*Y(1,3))*Y(2,2) + 
     &     2*(Ea(ee0012) + 2*Ea(ee0000)*Y(1,2))*Y(2,3))
        dE(ee1224) = -2*(2*Ea(ee0024)*Y(1,2) + 
     &     Ea(ee0022)*Y(1,4) + 
     &     (Ea(ee0014) + 2*Ea(ee0000)*Y(1,4))*Y(2,2) + 
     &     2*(Ea(ee0012) + 2*Ea(ee0000)*Y(1,2))*Y(2,4))
        dE(ee1233) = -2*(Ea(ee0033)*Y(1,2) + 
     &     2*Ea(ee0023)*Y(1,3) + 
     &     2*(Ea(ee0013) + 2*Ea(ee0000)*Y(1,3))*Y(2,3) + 
     &     (Ea(ee0012) + 2*Ea(ee0000)*Y(1,2))*Y(3,3))
        dE(ee1234) = -2*(Ea(ee0023)*Y(1,4) + 
     &     (Ea(ee0014) + 2*Ea(ee0000)*Y(1,4))*Y(2,3) + 
     &     Ea(ee0013)*Y(2,4) + 
     &     Y(1,3)*(Ea(ee0024) + 2*Ea(ee0000)*Y(2,4)) + 
     &     Ea(ee0012)*Y(3,4) + 
     &     Y(1,2)*(Ea(ee0034) + 2*Ea(ee0000)*Y(3,4)))
        dE(ee1244) = -2*(Ea(ee0044)*Y(1,2) + 
     &     2*Ea(ee0024)*Y(1,4) + 
     &     2*(Ea(ee0014) + 2*Ea(ee0000)*Y(1,4))*Y(2,4) + 
     &     (Ea(ee0012) + 2*Ea(ee0000)*Y(1,2))*Y(4,4))
        dE(ee1333) = -6*(Ea(ee0033)*Y(1,3) + 
     &     (Ea(ee0013) + 2*Ea(ee0000)*Y(1,3))*Y(3,3))
        dE(ee1334) = -2*(2*Ea(ee0034)*Y(1,3) + 
     &     Ea(ee0033)*Y(1,4) + 
     &     (Ea(ee0014) + 2*Ea(ee0000)*Y(1,4))*Y(3,3) + 
     &     2*(Ea(ee0013) + 2*Ea(ee0000)*Y(1,3))*Y(3,4))
        dE(ee1344) = -2*(Ea(ee0044)*Y(1,3) + 
     &     2*Ea(ee0034)*Y(1,4) + 
     &     2*(Ea(ee0014) + 2*Ea(ee0000)*Y(1,4))*Y(3,4) + 
     &     (Ea(ee0013) + 2*Ea(ee0000)*Y(1,3))*Y(4,4))
        dE(ee1444) = -6*(Ea(ee0044)*Y(1,4) + 
     &     (Ea(ee0014) + 2*Ea(ee0000)*Y(1,4))*Y(4,4))
	dE(ee2222) = -12*Y(2,2)*(Ea(ee0022) + Ea(ee0000)*Y(2,2))
        dE(ee2223) = -6*(Ea(ee0023)*Y(2,2) + 
     &     (Ea(ee0022) + 2*Ea(ee0000)*Y(2,2))*Y(2,3))
        dE(ee2224) = -6*(Ea(ee0024)*Y(2,2) + 
     &     (Ea(ee0022) + 2*Ea(ee0000)*Y(2,2))*Y(2,4))
        dE(ee2233) = -2*(Ea(ee0033)*Y(2,2) + 
     &     4*Y(2,3)*(Ea(ee0023) + Ea(ee0000)*Y(2,3)) + 
     &     (Ea(ee0022) + 2*Ea(ee0000)*Y(2,2))*Y(3,3))
        dE(ee2234) = -2*(Ea(ee0034)*Y(2,2) + 
     &     2*Ea(ee0024)*Y(2,3) + 
     &     2*(Ea(ee0023) + 2*Ea(ee0000)*Y(2,3))*Y(2,4) + 
     &     (Ea(ee0022) + 2*Ea(ee0000)*Y(2,2))*Y(3,4))
        dE(ee2244) = -2*(Ea(ee0044)*Y(2,2) + 
     &     4*Y(2,4)*(Ea(ee0024) + Ea(ee0000)*Y(2,4)) + 
     &     (Ea(ee0022) + 2*Ea(ee0000)*Y(2,2))*Y(4,4))
        dE(ee2333) = -6*(Ea(ee0033)*Y(2,3) + 
     &     (Ea(ee0023) + 2*Ea(ee0000)*Y(2,3))*Y(3,3))
        dE(ee2334) = -2*(2*Ea(ee0034)*Y(2,3) + 
     &     Ea(ee0033)*Y(2,4) + 
     &     (Ea(ee0024) + 2*Ea(ee0000)*Y(2,4))*Y(3,3) + 
     &     2*(Ea(ee0023) + 2*Ea(ee0000)*Y(2,3))*Y(3,4))
        dE(ee2344) = -2*(Ea(ee0044)*Y(2,3) + 
     &     2*Ea(ee0034)*Y(2,4) + 
     &     2*(Ea(ee0024) + 2*Ea(ee0000)*Y(2,4))*Y(3,4) + 
     &     (Ea(ee0023) + 2*Ea(ee0000)*Y(2,3))*Y(4,4))
        dE(ee2444) = -6*(Ea(ee0044)*Y(2,4) + 
     &     (Ea(ee0024) + 2*Ea(ee0000)*Y(2,4))*Y(4,4))
	dE(ee3333) = -12*Y(3,3)*(Ea(ee0033) + Ea(ee0000)*Y(3,3))
        dE(ee3334) = -6*(Ea(ee0034)*Y(3,3) + 
     &     (Ea(ee0033) + 2*Ea(ee0000)*Y(3,3))*Y(3,4))
        dE(ee3344) = -2*(Ea(ee0044)*Y(3,3) + 
     &     4*Y(3,4)*(Ea(ee0034) + Ea(ee0000)*Y(3,4)) + 
     &     (Ea(ee0033) + 2*Ea(ee0000)*Y(3,3))*Y(4,4))
        dE(ee3444) = -6*(Ea(ee0044)*Y(3,4) + 
     &     (Ea(ee0034) + 2*Ea(ee0000)*Y(3,4))*Y(4,4))
	dE(ee4444) = -12*Y(4,4)*(Ea(ee0044) + Ea(ee0000)*Y(4,4))
	dE(ee0000) = Ea(ee0000)
	dE(ee0011) = Ea(ee0011)
	dE(ee0012) = Ea(ee0012)
	dE(ee0013) = Ea(ee0013)
	dE(ee0014) = Ea(ee0014)
	dE(ee0022) = Ea(ee0022)
	dE(ee0023) = Ea(ee0023)
	dE(ee0024) = Ea(ee0024)
	dE(ee0033) = Ea(ee0033)
	dE(ee0034) = Ea(ee0034)
	dE(ee0044) = Ea(ee0044)

	ini = .TRUE.
	do i = 1, Nee
	  if( abs(Ea(i) - Eb(i) - dE(i)) .gt.
     &        .5D0*maxdev*abs(Ea(i) + Eb(i)) ) then
	    if( ini ) then
#ifdef COMPLEXPARA
	      print *, "Discrepancy in CEget:"
#else
	      print *, "Discrepancy in Eget:"
#endif
	      call XDumpPara(5, para, ldpara, " ")
	      ini = .FALSE.
	    endif
	    print *, coeffname(i,5), " a =", Ea(i)
	    print *, coeffname(i,5), " b =", Eb(i) + dE(i)
	  endif
	enddo
	end

