* looptools.h
* the header file for Fortran with all definitions for LoopTools
* this file is part of LoopTools
* last modified 13 Apr 06 th


#ifndef LOOPTOOLS_H__
#define LOOPTOOLS_H__

#define bb0 1
#define bb1 2
#define bb00 3
#define bb11 4
#define bb001 5
#define bb111 6
#define dbb0 7
#define dbb1 8
#define dbb00 9
#define dbb11 10

#define cc0 1
#define cc1 2
#define cc2 3
#define cc00 4
#define cc11 5
#define cc12 6
#define cc22 7
#define cc001 8
#define cc002 9
#define cc111 10
#define cc112 11
#define cc122 12
#define cc222 13
#define cc0000 14
#define cc0011 15
#define cc0012 16
#define cc0022 17
#define cc1111 18
#define cc1112 19
#define cc1122 20
#define cc1222 21
#define cc2222 22

#define dd0 1
#define dd1 2
#define dd2 3
#define dd3 4
#define dd00 5
#define dd11 6
#define dd12 7
#define dd13 8
#define dd22 9
#define dd23 10
#define dd33 11
#define dd001 12
#define dd002 13
#define dd003 14
#define dd111 15
#define dd112 16
#define dd113 17
#define dd122 18
#define dd123 19
#define dd133 20
#define dd222 21
#define dd223 22
#define dd233 23
#define dd333 24
#define dd0000 25
#define dd0011 26
#define dd0012 27
#define dd0013 28
#define dd0022 29
#define dd0023 30
#define dd0033 31
#define dd1111 32
#define dd1112 33
#define dd1113 34
#define dd1122 35
#define dd1123 36
#define dd1133 37
#define dd1222 38
#define dd1223 39
#define dd1233 40
#define dd1333 41
#define dd2222 42
#define dd2223 43
#define dd2233 44
#define dd2333 45
#define dd3333 46
#define dd00001 47
#define dd00002 48
#define dd00003 49
#define dd00111 50
#define dd00112 51
#define dd00113 52
#define dd00122 53
#define dd00123 54
#define dd00133 55
#define dd00222 56
#define dd00223 57
#define dd00233 58
#define dd00333 59
#define dd11111 60
#define dd11112 61
#define dd11113 62
#define dd11122 63
#define dd11123 64
#define dd11133 65
#define dd11222 66
#define dd11223 67
#define dd11233 68
#define dd11333 69
#define dd12222 70
#define dd12223 71
#define dd12233 72
#define dd12333 73
#define dd13333 74
#define dd22222 75
#define dd22223 76
#define dd22233 77
#define dd22333 78
#define dd23333 79
#define dd33333 80

#define ee0 1
#define ee1 2
#define ee2 3
#define ee3 4
#define ee4 5
#define ee00 6
#define ee11 7
#define ee12 8
#define ee13 9
#define ee14 10
#define ee22 11
#define ee23 12
#define ee24 13
#define ee33 14
#define ee34 15
#define ee44 16
#define ee001 17
#define ee002 18
#define ee003 19
#define ee004 20
#define ee111 21
#define ee112 22
#define ee113 23
#define ee114 24
#define ee122 25
#define ee123 26
#define ee124 27
#define ee133 28
#define ee134 29
#define ee144 30
#define ee222 31
#define ee223 32
#define ee224 33
#define ee233 34
#define ee234 35
#define ee244 36
#define ee333 37
#define ee334 38
#define ee344 39
#define ee444 40
#define ee0000 41
#define ee0011 42
#define ee0012 43
#define ee0013 44
#define ee0014 45
#define ee0022 46
#define ee0023 47
#define ee0024 48
#define ee0033 49
#define ee0034 50
#define ee0044 51
#define ee1111 52
#define ee1112 53
#define ee1113 54
#define ee1114 55
#define ee1122 56
#define ee1123 57
#define ee1124 58
#define ee1133 59
#define ee1134 60
#define ee1144 61
#define ee1222 62
#define ee1223 63
#define ee1224 64
#define ee1233 65
#define ee1234 66
#define ee1244 67
#define ee1333 68
#define ee1334 69
#define ee1344 70
#define ee1444 71
#define ee2222 72
#define ee2223 73
#define ee2224 74
#define ee2233 75
#define ee2234 76
#define ee2244 77
#define ee2333 78
#define ee2334 79
#define ee2344 80
#define ee2444 81
#define ee3333 82
#define ee3334 83
#define ee3344 84
#define ee3444 85
#define ee4444 86

#define KeyA0 2**0
#define KeyBget 2**2
#define KeyC0 2**4
#define KeyD0 2**6
#define KeyE0 2**8
#define KeyEget 2**10
#define KeyCEget 2**12
#define KeyAll 5461

#define DebugB 2**0
#define DebugC 2**1
#define DebugD 2**2
#define DebugE 2**3
#define DebugAll 15

#define Bval(id,p) cache(p+id,1)
#define BvalC(id,p) cache(p+id,2)
#define Cval(id,p) cache(p+id,3)
#define CvalC(id,p) cache(p+id,4)
#define Dval(id,p) cache(p+id,5)
#define DvalC(id,p) cache(p+id,6)
#define Eval(id,p) cache(p+id,7)
#define EvalC(id,p) cache(p+id,8)

#define Ccache 0
#define Dcache 0

#endif

	double complex cache(2,8)
	common /ltvars/ cache

	double complex A0, A0C, B0i, B0iC
	double complex B0, B1, B00, B11, B001, B111
	double complex B0C, B1C, B00C, B11C, B001C, B111C
	double complex DB0, DB1, DB00, DB11
	double complex DB0C, DB1C, DB00C, DB11C
	double complex C0, C0C, C0i, C0iC
	double complex D0, D0C, D0i, D0iC
	double complex E0, E0C, E0i, E0iC
	double complex Li2, Li2C
	integer Bget, BgetC, Cget, CgetC, Dget, DgetC, Eget, EgetC
	double precision getmudim, getdelta, getlambda, getmaxdev
	integer getwarndigits, geterrdigits
	integer getversionkey, getdebugkey
	integer getcachelast

	external A0, A0C, B0i, B0iC
	external B0, B1, B00, B11, B001, B111
	external B0C, B1C, B00C, B11C, B001C, B111C
	external DB0, DB1, DB00, DB11
	external DB0C, DB1C, DB00C, DB11C
	external C0, C0C, C0i, C0iC
	external D0, D0C, D0i, D0iC
	external E0, E0C, E0i, E0iC
	external Li2, Li2C
	external Bget, BgetC, Cget, CgetC, Dget, DgetC, Eget, EgetC
	external getmudim, getdelta, getlambda, getmaxdev
	external getwarndigits, geterrdigits
	external getversionkey, getdebugkey
	external setcachelast, getcachelast

