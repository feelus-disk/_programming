/* -*- C++ -*-
	clooptools.h
		the C/C++ header file with all definitions for LoopTools
		this file is part of LoopTools
		last modified 21 Dec 06 th
		dgrell 2008-01 for Herwig++
		sapronov 2009-03 for MCSANC
*/


#ifndef MCSANC_clooptools_h_
#define MCSANC_clooptools_h_

/** complex defn for Looptools*/
struct DOUBLE_COMPLEX { double re, im; };
typedef const DOUBLE_COMPLEX CDOUBLE_COMPLEX;

#include <complex>
typedef std::complex<double> double_complex;

#define AARGS(t) t(m)

#define BARGS(t) t(p), t(m1), t(m2)

#define CARGS(t) t(p1), t(p2), t(p1p2), t(m1), t(m2), t(m3)

#define DARGS(t) t(p1), t(p2), t(p3), t(p4), t(p1p2), t(p2p3), \
  t(m1), t(m2), t(m3), t(m4)

#define EARGS(t) t(p1), t(p2), t(p3), t(p4), t(p5), \
  t(p1p2), t(p2p3), t(p3p4), t(p4p5), t(p5p1), \
  t(m1), t(m2), t(m3), t(m4), t(m5)

/****************************************************************/

extern "C" {

extern void a0sub_(DOUBLE_COMPLEX *result, AARGS(const double *));
// extern void a0subc_(DOUBLE_COMPLEX *result, AARGS(CDOUBLE_COMPLEX *));
extern void a00sub_(DOUBLE_COMPLEX *result, AARGS(const double *));
// extern void a00subc_(DOUBLE_COMPLEX *result, AARGS(CDOUBLE_COMPLEX *));

extern long bget_(BARGS(const double *));
// extern long bgetc_(BARGS(CDOUBLE_COMPLEX *));

extern void c0sub_(DOUBLE_COMPLEX *result, CARGS(const double *));
// extern void c0subc_(DOUBLE_COMPLEX *result, CARGS(CDOUBLE_COMPLEX *));
extern long cget_(CARGS(const double *));
// extern long cgetc_(CARGS(CDOUBLE_COMPLEX *));

extern void d0sub_(DOUBLE_COMPLEX *result, DARGS(const double *));
// extern void d0subc_(DOUBLE_COMPLEX *result, DARGS(CDOUBLE_COMPLEX *));
extern long dget_(DARGS(const double *));
// extern long dgetc_(DARGS(CDOUBLE_COMPLEX *));

extern void e0sub_(DOUBLE_COMPLEX *result, EARGS(const double *));
// extern void e0subc_(DOUBLE_COMPLEX *result, EARGS(CDOUBLE_COMPLEX *));
extern long eget_(EARGS(const double *));
// extern long egetc_(EARGS(CDOUBLE_COMPLEX *));

extern void li2sub_(DOUBLE_COMPLEX *result, const double *x);
extern void li2csub_(DOUBLE_COMPLEX *result, CDOUBLE_COMPLEX *x);

extern void ffini_(void);
extern void ffexi_(void);

extern void clearcache_(void);
extern void markcache_(void);
extern void restorecache_(void);

extern struct {		/* MUST match common block ltvars in lt.h! */
  DOUBLE_COMPLEX cache[8][2];
  DOUBLE_COMPLEX savedptr[8];
  double maxdev;
  long serial, warndigits, errdigits, versionkey;
  long debugkey, debugfrom, debugto;
} ltvars_;

extern struct {		/* MUST match common block ffregul in ff.h! */
  double mudim, delta, lambda;
} ffregul_;

}

/****************************************************************/

namespace Looptools {
    inline double_complex ToComplex(DOUBLE_COMPLEX c) {
      return double_complex(c.re, c.im);
    }

    /**
     *  Looptools initialisation
     */
    void ffini(std::string logfilename = std::string("Looptools.log"));

    /**
     *  Looptools termination
     */
    void ffexi(std::string logfilename = std::string("Looptools.log"));

enum {
  bb0, bb1, bb00, bb11, bb001, bb111, dbb0, dbb1, dbb00, dbb11,
  Nbb
};

enum {
  cc0, cc1, cc2, cc00, cc11, cc12, cc22, cc001, cc002, cc111, cc112,
  cc122, cc222, cc0000, cc0011, cc0012, cc0022, cc1111, cc1112, cc1122,
  cc1222, cc2222,
  Ncc
};

enum {
  dd0, dd1, dd2, dd3, dd00, dd11, dd12, dd13, dd22, dd23, dd33,
  dd001, dd002, dd003, dd111, dd112, dd113, dd122, dd123, dd133, dd222,
  dd223, dd233, dd333, dd0000, dd0011, dd0012, dd0013, dd0022, dd0023,
  dd0033, dd1111, dd1112, dd1113, dd1122, dd1123, dd1133, dd1222, 
  dd1223, dd1233, dd1333, dd2222, dd2223, dd2233, dd2333, dd3333, 
  dd00001, dd00002, dd00003, dd00111, dd00112, dd00113, dd00122, 
  dd00123, dd00133, dd00222, dd00223, dd00233, dd00333, dd11111, 
  dd11112, dd11113, dd11122, dd11123, dd11133, dd11222, dd11223, 
  dd11233, dd11333, dd12222, dd12223, dd12233, dd12333, dd13333, 
  dd22222, dd22223, dd22233, dd22333, dd23333, dd33333,
  Ndd
};

enum {
  ee0, ee1, ee2, ee3, ee4, ee00, ee11, ee12, ee13, ee14, ee22, ee23, 
  ee24, ee33, ee34, ee44, ee001, ee002, ee003, ee004, ee111, ee112, 
  ee113, ee114, ee122, ee123, ee124, ee133, ee134, ee144, ee222,
  ee223, ee224, ee233, ee234, ee244, ee333, ee334, ee344, ee444,
  ee0000, ee0011, ee0012, ee0013, ee0014, ee0022, ee0023, ee0024,
  ee0033, ee0034, ee0044, ee1111, ee1112, ee1113, ee1114, ee1122, 
  ee1123, ee1124, ee1133, ee1134, ee1144, ee1222, ee1223, ee1224,
  ee1233, ee1234, ee1244, ee1333, ee1334, ee1344, ee1444, ee2222,
  ee2223, ee2224, ee2233, ee2234, ee2244, ee2333, ee2334, ee2344,
  ee2444, ee3333, ee3334, ee3344, ee3444, ee4444,
  Nee
};

enum {
  KeyA0 = 1,
  KeyBget = 1<<2,
  KeyC0 = 1<<4,
  KeyD0 = 1<<6,
  KeyE0 = 1<<8,
  KeyEget = 1<<10,
  KeyEgetC = 1<<12,
  KeyALL = KeyA0 + KeyBget + KeyC0 + KeyD0 + KeyE0 + KeyEget + KeyEgetC
};

enum {
  DebugB = 1,
  DebugC = 1<<1,
  DebugD = 1<<2,
  DebugE = 1<<3,
  DebugAll = DebugB + DebugC + DebugD + DebugE
};


inline double_complex A0(AARGS(const double ))
{
  DOUBLE_COMPLEX result;
  a0sub_(&result, AARGS(&));
  return ToComplex(result);
}

// inline double_complex A0C(AARGS(const double_complex ))
// {
//   DOUBLE_COMPLEX result;
//   a0subc_(&result, AARGS(_Fcp_));
//   return ToComplex(result);
// }

inline double_complex A00(AARGS(const double ))
{
  DOUBLE_COMPLEX result;
  a00sub_(&result, AARGS(&));
  return ToComplex(result);
}

// inline double_complex A00C(AARGS(const double_complex ))
// {
//   DOUBLE_COMPLEX result;
//   a00subc_(&result, AARGS(_Fcp_));
//   return ToComplex(result);
// }

/****************************************************************/

inline long Bget(BARGS(const double ))
{
  return bget_(BARGS(&));
}

// inline long BgetC(BARGS(const double_complex ))
// {
//   return bgetc_(BARGS(_Fcp_));
// }

inline DOUBLE_COMPLEX *Bcache(const long integral)
  { return &ltvars_.cache[0][integral]; }

inline DOUBLE_COMPLEX *BcacheC(const long integral)
  { return &ltvars_.cache[1][integral]; }

inline double_complex Bval(const long i, const long integral)
  { return ToComplex(Bcache(integral)[i]); }

inline double_complex BvalC(const long i, const long integral)
  { return ToComplex(BcacheC(integral)[i]); }

inline double_complex B0i(const long i, BARGS(const double ))
  { return Bval(i, Bget(BARGS())); }

// inline double_complex B0iC(const long i, BARGS(const double_complex ))
//   { return BvalC(i, BgetC(BARGS())); }

inline double_complex B0(BARGS(const double ))
  { return B0i(bb0, BARGS()); }
inline double_complex B1(BARGS(const double ))
  { return B0i(bb1, BARGS()); }
inline double_complex B00(BARGS(const double ))
  { return B0i(bb00, BARGS()); }
inline double_complex B11(BARGS(const double ))
  { return B0i(bb11, BARGS()); }
inline double_complex B001(BARGS(const double ))
  { return B0i(bb001, BARGS()); }
inline double_complex B111(BARGS(const double ))
  { return B0i(bb111, BARGS()); }
inline double_complex DB0(BARGS(const double ))
  { return B0i(dbb0, BARGS()); }
inline double_complex DB1(BARGS(const double ))
  { return B0i(dbb1, BARGS()); }
inline double_complex DB00(BARGS(const double ))
  { return B0i(dbb00, BARGS()); }
inline double_complex DB11(BARGS(const double ))
  { return B0i(dbb11, BARGS()); }

// inline double_complex B0C(BARGS(const double_complex ))
//   { return B0iC(bb0, BARGS()); }
// inline double_complex B1C(BARGS(const double_complex ))
//   { return B0iC(bb1, BARGS()); }
// inline double_complex B00C(BARGS(const double_complex ))
//   { return B0iC(bb00, BARGS()); }
// inline double_complex B11C(BARGS(const double_complex ))
//   { return B0iC(bb11, BARGS()); }
// inline double_complex B001C(BARGS(const double_complex ))
//   { return B0iC(bb001, BARGS()); }
// inline double_complex B111C(BARGS(const double_complex ))
//   { return B0iC(bb111, BARGS()); }
// inline double_complex DB0C(BARGS(const double_complex ))
//   { return B0iC(dbb0, BARGS()); }
// inline double_complex DB1C(BARGS(const double_complex ))
//   { return B0iC(dbb1, BARGS()); }
// inline double_complex DB00C(BARGS(const double_complex ))
//   { return B0iC(dbb00, BARGS()); }
// inline double_complex DB11C(BARGS(const double_complex ))
//   { return B0iC(dbb11, BARGS()); }

/****************************************************************/

inline double_complex C0(CARGS(const double ))
{
  DOUBLE_COMPLEX result;
  c0sub_(&result, CARGS(&));
  return ToComplex(result);
}

// inline double_complex C0C(CARGS(const double_complex ))
// {
//   DOUBLE_COMPLEX result;
//   c0subc_(&result, CARGS(_Fcp_));
//   return ToComplex(result);
// }

inline long Cget(CARGS(const double ))
{
  return cget_(CARGS(&));
}

// inline long CgetC(CARGS(const double_complex ))
// {
//   return cgetc_(CARGS(_Fcp_));
// }

inline DOUBLE_COMPLEX *Ccache(const long integral)
  { return &ltvars_.cache[2][integral]; }

inline DOUBLE_COMPLEX *CcacheC(const long integral)
  { return &ltvars_.cache[3][integral]; }

inline double_complex Cval(const long i, const long integral)
  { return ToComplex(Ccache(integral)[i]); }

inline double_complex CvalC(const long i, const long integral)
  { return ToComplex(CcacheC(integral)[i]); }

inline double_complex C0i(const long i, CARGS(const double ))
  { return Cval(i, Cget(CARGS())); }

// inline double_complex C0iC(const long i, CARGS(const double_complex ))
//   { return CvalC(i, CgetC(CARGS())); }

/****************************************************************/

inline double_complex D0(DARGS(const double ))
{
  DOUBLE_COMPLEX result;
  d0sub_(&result, DARGS(&));
  return ToComplex(result);
}

// inline double_complex D0C(DARGS(const double_complex ))
// {
//   DOUBLE_COMPLEX result;
//   d0subc_(&result, DARGS(&));
//   return ToComplex(result);
// }

inline long Dget(DARGS(const double ))
{
  return dget_(DARGS(&));
}

// inline long DgetC(DARGS(const double_complex ))
// {
//   return dgetc_(DARGS(_Fcp_));
// }

inline DOUBLE_COMPLEX *Dcache(const long integral)
  { return &ltvars_.cache[4][integral]; }

inline DOUBLE_COMPLEX *DcacheC(const long integral)
  { return &ltvars_.cache[5][integral]; }

inline double_complex Dval(const long i, const long integral)
  { return ToComplex(Dcache(integral)[i]); }

inline double_complex DvalC(const long i, const long integral)
  { return ToComplex(DcacheC(integral)[i]); }

inline double_complex D0i(const long i, DARGS(const double ))
  { return Dval(i, Dget(DARGS())); }

// inline double_complex D0iC(const long i, DARGS(const double_complex ))
//   { return DvalC(i, DgetC(DARGS())); }

/****************************************************************/

inline double_complex E0(EARGS(const double ))
{
  DOUBLE_COMPLEX result;
  e0sub_(&result, EARGS(&));
  return ToComplex(result);
}

// inline double_complex E0C(EARGS(const double_complex ))
// {
//   DOUBLE_COMPLEX result;
//   e0subc_(&result, EARGS(&));
//   return ToComplex(result);
// }

inline long Eget(EARGS(const double ))
{
  return eget_(EARGS(&));
}

// inline long EgetC(EARGS(const double_complex ))
// {
//   return egetc_(EARGS(_Fcp_));
// }

inline DOUBLE_COMPLEX *Ecache(const long integral)
  { return &ltvars_.cache[6][integral]; }

inline DOUBLE_COMPLEX *EcacheC(const long integral)
  { return &ltvars_.cache[7][integral]; }

inline double_complex Eval(const long i, const long integral)
  { return ToComplex(Ecache(integral)[i]); }

inline double_complex EvalC(const long i, const long integral)
  { return ToComplex(EcacheC(integral)[i]); }

inline double_complex E0i(const long i, EARGS(const double ))
  { return Eval(i, Eget(EARGS())); }

// inline double_complex E0iC(const long i, EARGS(const double_complex ))
//   { return EvalC(i, EgetC(EARGS())); }

/****************************************************************/

inline double_complex Li2(const double x)
{
  DOUBLE_COMPLEX result;
  li2sub_(&result, &x);
  return ToComplex(result);
}

// inline double_complex Li2C(const double_complex x)
// {
//   DOUBLE_COMPLEX result;
//   li2csub_(&result, _Fcp_(x));
//   return ToComplex(result);
// }

/****************************************************************/

#define clearcache clearcache_
#define markcache markcache_
#define restorecache restorecache_
// #define ffini ffini_
// #define ffexi ffexi_


inline void setmudim(const double mudim)
{
  ffregul_.mudim = mudim;
  clearcache();
}

inline double getmudim() { return ffregul_.mudim; }


inline void setdelta(const double delta)
{
  ffregul_.delta = delta;
  clearcache();
}

inline double getdelta() { return ffregul_.delta; }


inline void setlambda(const double lambda)
{
  ffregul_.lambda = lambda;
  clearcache();
}

inline double getlambda() { return ffregul_.lambda; }


inline void setmaxdev(const double maxdev)
{
  ltvars_.maxdev = maxdev;
}

inline double getmaxdev() { return ltvars_.maxdev; }


inline void setwarndigits(const long warndigits)
{
  ltvars_.warndigits = warndigits;
}

inline long getwarndigits() { return ltvars_.warndigits; }


inline void seterrdigits(const long errdigits)
{
  ltvars_.errdigits = errdigits;
}

inline long geterrdigits() { return ltvars_.errdigits; }


inline void setversionkey(const long versionkey)
{
  ltvars_.versionkey = versionkey;
  clearcache();
}

inline long getversionkey() { return ltvars_.versionkey; }


inline void setdebugkey(const long debugkey)
{
  ltvars_.debugkey = debugkey;
}

inline long getdebugkey() { return ltvars_.debugkey; }


inline void setdebugrange(const long debugfrom, const long debugto)
{
  ltvars_.debugfrom = debugfrom;
  ltvars_.debugto = debugto;
}

} // namespace Looptools
#endif

