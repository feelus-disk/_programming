* ini.F
* routines for initializing and setting some parameters
* this file is part of LoopTools
* last modified 7 Dec 05 th

#include "defs.h"


	subroutine clearcache
	implicit none

#include "lt.h"

	integer i

	do i = 1, ncaches
	  cacheptr(1,1,i) = 0
	  cacheptr(1,2,i) = 0
	enddo
	end

************************************************************************

	subroutine markcache
	implicit none

#include "lt.h"

	integer i

	do i = 1, ncaches
	  savedptr(1,i) = cacheptr(1,1,i)
	  savedptr(2,i) = cacheptr(1,2,i)
	enddo
	end

************************************************************************

	subroutine restorecache
	implicit none

#include "lt.h"

	integer i

	do i = 1, ncaches
	  cacheptr(1,1,i) = savedptr(1,i)
	  cacheptr(1,2,i) = savedptr(2,i)
	enddo
	end

************************************************************************
* Legacy function, provided for compatibility only.
* Works only approximately as before!

	subroutine setcachelast(base, offset)
	implicit none
	double complex base(*)
	integer offset

	if( offset .eq. 0 ) then
	  call clearcache
	else
	  call restorecache
	endif
	end

************************************************************************
* Legacy function, provided for compatibility only.
* Works only approximately as before!

	integer function getcachelast(base)
	implicit none
	double complex base(*)

	getcachelast = 1
	call markcache
	end

************************************************************************

	subroutine setmudim(mudim_)
	implicit none
	double precision mudim_

#include "lt.h"

	mudim = mudim_
	call clearcache
	end

************************************************************************

	double precision function getmudim()
	implicit none

#include "lt.h"

	getmudim = mudim
	end

************************************************************************

	subroutine setdelta(delta_)
	implicit none
	double precision delta_

#include "lt.h"

	delta = delta_
	call clearcache
	end

************************************************************************

	double precision function getdelta()
	implicit none

#include "lt.h"

	getdelta = delta
	end

************************************************************************

	subroutine setlambda(lambda_)
	implicit none
	double precision lambda_

#include "lt.h"

	lambda = lambda_
	call clearcache
	end

************************************************************************

	double precision function getlambda()
	implicit none

#include "lt.h"

	getlambda = lambda
	end

************************************************************************

	subroutine setmaxdev(maxdev_)
	implicit none
	double precision maxdev_

#include "lt.h"

	maxdev = maxdev_
	end

************************************************************************

	double precision function getmaxdev()
	implicit none

#include "lt.h"

	getmaxdev = maxdev
	end

************************************************************************

	subroutine setwarndigits(warndigits_)
	implicit none
	integer warndigits_

#include "lt.h"

	warndigits = warndigits_
	end

************************************************************************

	integer function getwarndigits()
	implicit none

#include "lt.h"

	getwarndigits = warndigits
	end

************************************************************************

	subroutine seterrdigits(errdigits_)
	implicit none
	integer errdigits_

#include "lt.h"

	errdigits = errdigits_
	end

************************************************************************

	integer function geterrdigits()
	implicit none

#include "lt.h"

	geterrdigits = errdigits
	end

************************************************************************

	subroutine setversionkey(versionkey_)
	implicit none
	integer versionkey_

#include "lt.h"

	versionkey = versionkey_
	call clearcache
	end

************************************************************************

	integer function getversionkey()
	implicit none

#include "lt.h"

	getversionkey = versionkey
	end

************************************************************************

	subroutine setdebugkey(debugkey_)
	implicit none
	integer debugkey_

#include "lt.h"

	debugkey = debugkey_
	end

************************************************************************

	integer function getdebugkey()
	implicit none

#include "lt.h"

	getdebugkey = debugkey
	end

************************************************************************

	subroutine setdebugrange(debugfrom_, debugto_)
	implicit none
	integer debugfrom_, debugto_

#include "lt.h"

	debugfrom = debugfrom_
	debugto = debugto_
	end

************************************************************************

* This silly subroutine is called from ffini while determining
* the working precision of the machine we're running on.
* It works around the optimizer to guarantee that we're not in
* fact determining the precision of the FPU registers.

	subroutine ffset(res, x)
	implicit none
	DOUBLE PRECISION res, x

	res = x
	end

************************************************************************

	block data LTNameData
	implicit none
	integer i

	character*6 paraname(Pee,2:5)
	common /ltparanames/ paraname

	character*8 coeffname(Nee,2:5)
	common /ltcoeffnames/ coeffname

	data (paraname(i,2), i = 1, Pbb) /
     &    "p", "m1", "m2" /

	data (paraname(i,3), i = 1, Pcc) /
     &    "p1", "p2", "p1p2", "m1", "m2", "m3" /

	data (paraname(i,4), i = 1, Pdd) /
     &    "p1", "p2", "p3", "p4", "p1p2", "p2p3",
     &    "m1", "m2", "m3", "m4" /

	data (paraname(i,5), i = 1, Pee) /
     &    "p1", "p2", "p3", "p4", "p5",
     &    "p1p2", "p2p3", "p3p4", "p4p5", "p5p1",
     &    "m1", "m2", "m3", "m4", "m5" /

	data (coeffname(i,2), i = 1, Nbb) /
     &    "bb0", "bb1", "bb00", "bb11", "bb001", "bb111",
     &    "dbb0", "dbb1", "dbb00", "dbb11" /

	data (coeffname(i,3), i = 1, Ncc) /
     &    "cc0", "cc1", "cc2", "cc00", "cc11", "cc12", "cc22",
     &    "cc001", "cc002", "cc111", "cc112", "cc122", "cc222",
     &    "cc0000", "cc0011", "cc0012", "cc0022", "cc1111",
     &    "cc1112", "cc1122", "cc1222", "cc2222" /

	data (coeffname(i,4), i = 1, Ndd) /
     &    "dd0", "dd1", "dd2", "dd3", "dd00", "dd11", "dd12",
     &    "dd13", "dd22", "dd23", "dd33", "dd001", "dd002", "dd003",
     &    "dd111", "dd112", "dd113", "dd122", "dd123", "dd133",
     &    "dd222", "dd223", "dd233", "dd333", "dd0000", "dd0011",
     &    "dd0012", "dd0013", "dd0022", "dd0023", "dd0033", "dd1111",
     &    "dd1112", "dd1113", "dd1122", "dd1123", "dd1133", "dd1222",
     &    "dd1223", "dd1233", "dd1333", "dd2222", "dd2223", "dd2233",
     &    "dd2333", "dd3333", "dd00001", "dd00002", "dd00003",
     &    "dd00111", "dd00112", "dd00113", "dd00122", "dd00123",
     &    "dd00133", "dd00222", "dd00223", "dd00233", "dd00333",
     &    "dd11111", "dd11112", "dd11113", "dd11122", "dd11123",
     &    "dd11133", "dd11222", "dd11223", "dd11233", "dd11333",
     &    "dd12222", "dd12223", "dd12233", "dd12333", "dd13333",
     &    "dd22222", "dd22223", "dd22233", "dd22333", "dd23333",
     &    "dd33333" /

	data (coeffname(i,5), i = 1, Nee) /
     &    "ee0", "ee1", "ee2", "ee3", "ee4", "ee00", "ee11",
     &    "ee12", "ee13", "ee14", "ee22", "ee23", "ee24", "ee33",
     &    "ee34", "ee44", "ee001", "ee002", "ee003", "ee004",
     &    "ee111", "ee112", "ee113", "ee114", "ee122", "ee123",
     &    "ee124", "ee133", "ee134", "ee144", "ee222", "ee223",
     &    "ee224", "ee233", "ee234", "ee244", "ee333", "ee334",
     &    "ee344", "ee444", "ee0000", "ee0011", "ee0012", "ee0013",
     &    "ee0014", "ee0022", "ee0023", "ee0024", "ee0033", "ee0034",
     &    "ee0044", "ee1111", "ee1112", "ee1113", "ee1114", "ee1122",
     &    "ee1123", "ee1124", "ee1133", "ee1134", "ee1144", "ee1222",
     &    "ee1223", "ee1224", "ee1233", "ee1234", "ee1244", "ee1333",
     &    "ee1334", "ee1344", "ee1444", "ee2222", "ee2223", "ee2224",
     &    "ee2233", "ee2234", "ee2244", "ee2333", "ee2334", "ee2344",
     &    "ee2444", "ee3333", "ee3334", "ee3344", "ee3444", "ee4444" /
	end

