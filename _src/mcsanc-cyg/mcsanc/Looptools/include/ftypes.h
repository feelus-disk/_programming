#ifndef ftypes_h__
#define ftypes_h__

#if UNDERSCORE
#define FORTRAN(s) s##_
#else
#define FORTRAN(s) s
#endif

typedef int INTEGER;
typedef const INTEGER CINTEGER;
typedef double DOUBLE_PRECISION;
typedef const DOUBLE_PRECISION CDOUBLE_PRECISION;
typedef struct { DOUBLE_PRECISION re, im; } DOUBLE_COMPLEX;
typedef const DOUBLE_COMPLEX CDOUBLE_COMPLEX;

#ifdef __cplusplus

#include <complex>
typedef std::complex<double> double_complex;
#define ToComplex(c) double_complex(c.re, c.im)
#define ToComplex2(r,i) double_complex(r, i)
#define Re(x) x.real()
#define Im(x) x.imag()

#else

typedef DOUBLE_COMPLEX double_complex;
#define ToComplex(c) c
#define ToComplex2(r,i) (double_complex){r, i}
#define Re(x) x.re
#define Im(x) x.im

#endif

#endif

