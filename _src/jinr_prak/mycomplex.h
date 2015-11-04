#include <math.h>

typedef struct complex_t
{
  double re, im;
} complex_t;

complex_t complex(double re, double im)
{
  complex_t x;
  x.re=re;
  x.im=im;
  return x;
}
double dcabs(complex_t x)
{ return sqrt(x.re*x.re+x.im*x.im);   }
double dcarg(complex_t x)
{ return atan2(x.im,x.re);   }

complex_t caddc(complex_t a, complex_t b)
{
  a.re+=b.re;
  a.im+=b.im;
  return a;
}
complex_t * c_addc(complex_t * a, complex_t b)
{
  a->re+=b.re;
  a->im+=b.im;
  return a;
}
complex_t cmulr(complex_t a, double b)
{
  a.re*=b;
  a.im*=b;
  return a;
}
complex_t * c_mulr(complex_t * a, double b)
{
  a->re*=b;
  a->im*=b;
  return a;
}
complex_t cneg(complex_t a)
{
  a.re=-a.re;
  a.im=-a.im;
  return a;
}
complex_t * c_neg(complex_t * a)
{
  a->re=-a->re;
  a->im=-a->im;
  return a;
}
complex_t cconj(complex_t x)
{
  x.im=-x.im;
  return x;
}
complex_t * c_conj(complex_t * px)
{ 
  px->im=-px->im;  
  return px;
}
complex_t cmulc(complex_t a, complex_t b)
{
  complex_t r;
  r.re=a.re*b.re-a.im*b.im;
  r.im=a.re*b.im+a.im*b.re;
  return r;
}
complex_t * c_mulc(complex_t * a, complex_t b)
{
  complex_t r;
  r.re=a->re*b.re-a->im*b.im;
  r.im=a->re*b.im+a->im*b.re;
  *a=r;
  return a;
}
complex_t cdivc(complex_t x, complex_t y)
{
  complex_t r;
  r.re=(x.re*y.re+x.im*y.im)/(y.re*y.re+y.im*y.im);
  r.im=(y.re*x.im-x.re*y.im)/(y.re*y.re+y.im*y.im);
  return r;
}
