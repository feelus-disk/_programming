* defs.h
* internal definitions for the LoopTools routines
* this file is part of LoopTools
* last modified 13 Apr 06 th


#ifdef COMPLEXPARA

#define XA0 A0C
#define XA0b A0bC
#define XA0sub A0subC
#define XA00 A00C
#define XA00sub A00subC
#define XB0 B0C
#define XB1 B1C
#define XB00 B00C
#define XB11 B11C
#define XB001 B001C
#define XB111 B111C
#define XDB0 DB0C
#define XDB1 DB1C
#define XDB00 DB00C
#define XDB11 DB11C
#define XB0i B0iC
#define XBget BgetC
#define XBcoeff BcoeffC
#define XBcoeffa BcoeffaC
#define XC0 C0C
#define XC0i C0iC
#define XCget CgetC
#define XCcoeff CcoeffC
#define XD0 D0C
#define XD0i D0iC
#define XDget DgetC
#define XDcoeff DcoeffC
#define XE0 E0C
#define XE0sub E0subC
#define XE0i E0iC
#define XEget EgetC
#define XEcoeff EcoeffC
#define XEcoeffa EcoeffaC
#define XEcoeffb EcoeffbC
#define XEcheck EcheckC
#define XltEgram ltEgramC
#define XLUDecomp LUDecompC
#define XLUBackSubst LUBackSubstC
#define XDet ltDetC
#define XInverse ltInverseC
#define XDumpPara DumpParaC
#define XDumpCoeff DumpCoeffC
#define XLi2 Li2C
#define XLi2sub Li2Csub
#define Xfpij2 cfpij2
#define Xffa0 ffca0
#define Xffb0 ffcb0
#define Xffb1 ffcb1
#define Xffb2p ffcb2p
#define Xffdb0 ffcdb0

#define RC 2
#define DVAR double complex
#define QVAR double complex
#define QREAL double precision
#define QEXT(x) x

#else

#define XA0 A0
#define XA0b A0b
#define XA0sub A0sub
#define XA00 A00
#define XA00sub A00sub
#define XB0 B0
#define XB1 B1
#define XB00 B00
#define XB11 B11
#define XB001 B001
#define XB111 B111
#define XDB0 DB0
#define XDB1 DB1
#define XDB00 DB00
#define XDB11 DB11
#define XB0i B0i
#define XBget Bget
#define XBcoeff Bcoeff
#define XBcoeffa Bcoeffa
#define XC0 C0
#define XC0i C0i
#define XCget Cget
#define XCcoeff Ccoeff
#define XD0 D0
#define XD0i D0i
#define XDget Dget
#define XDcoeff Dcoeff
#define XE0 E0
#define XE0sub E0sub
#define XE0i E0i
#define XEget Eget
#define XEcoeff Ecoeff
#define XEcoeffa Ecoeffa
#define XEcoeffb Ecoeffb
#define XEcheck Echeck
#define XltEgram ltEgram
#define XLUDecomp LUDecomp
#define XLUBackSubst LUBackSubst
#define XDet ltDet
#define XInverse ltInverse
#define XDumpPara DumpPara
#define XDumpCoeff DumpCoeff
#define XLi2 Li2
#define XLi2sub Li2sub
#define Xfpij2 fpij2
#define Xffa0 ffxa0
#define Xffb0 ffxb0
#define Xffb1 ffxb1
#define Xffb2p ffxb2p
#define Xffdb0 ffxdb0

#define RC 1
#define DVAR double precision
#ifdef QUAD
#define QVAR real*16
#else
#define QVAR double precision
#define QEXT(x) x
#endif
#define QREAL QVAR

#endif

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
#define Pbb 3
#define Nbb 10

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
#define Pcc 6
#define Ncc 22

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
#define Pdd 10
#define Ndd 80

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
#define Pee 15
#define Nee 86

#define KeyA0 0
#define KeyBget 2
#define KeyC0 4
#define KeyD0 6
#define KeyE0 8
#define KeyEget 10
#define KeyEgetC 12

#define DebugB 0
#define DebugC 1
#define DebugD 2
#define DebugE 3

#define Bval(id,p) cache(p+id,RC)
#define Cval(id,p) cache(p+id,RC+2)
#define Dval(id,p) cache(p+id,RC+4)
#define Eval(id,p) cache(p+id,RC+6)
#define Nval(n,id,p) cache(p+id,RC+2*n-4)

#define Sgn(i) (1 - 2*iand(i,1))

#ifndef KIND
#define KIND 1
#endif

*#define WARNINGS

