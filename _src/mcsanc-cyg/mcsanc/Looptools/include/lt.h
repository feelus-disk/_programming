* lt.h
* internal common blocks for the LoopTools routines
* this file is part of LoopTools
* last modified 23 Nov 05 th


#include "ff.h"

* the cache-pointer structure is (see cache.c):
* 1. int valid
* 2. Node *last
* 3. Node *first
* 4. (not used)

	integer ncaches
	parameter (ncaches = 8)

	integer*8 cacheptr(KIND,4,ncaches)
	integer*8 savedptr(2,ncaches)
	double precision maxdev
	integer serial, warndigits, errdigits, versionkey
	integer debugkey, debugfrom, debugto

	common /ltvars/
     &    cacheptr, savedptr,
     &    maxdev,
     &    serial, warndigits, errdigits, versionkey,
     &    debugkey, debugfrom, debugto

	double complex cache(2,ncaches)
	equivalence (cacheptr, cache)
