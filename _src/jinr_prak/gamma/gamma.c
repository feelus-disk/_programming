#include <stdio.h>
#include <math.h>
#include <assert.h>
#include "gamma.h"
int i;//for(int i....)

/*
double Bernulli(int x)//оптимизировать
{
  switch(x)
  {
  case 2: return 1./6;
  case 4: return -1./30;
  case 6: return 1./42;
  case 8: return -1./30;
  case 10: return 5./66;
  case 12: return -691./2730;
  case 14: return 7./6;
  case 16: return -3617./510;
  default: assert(0);
  }
  return 0;
}
double intexp(double x, int p)
{
  int i;
  double m=1;
  for(i=0; i<p; i++)
    m*=x;
  return m;
}
*/
double AssimptGamma(double z)
{
  static double bernulli[]=
  {      1./6   /2/1,
	-1./30  /4/3,
	 1./42  /6/5,
	-1./30  /8/7,
	 5./66  /10/9,
      -691./2730/12/11,
 	 7./6   /14/13,
     -3617./510 /16/15,
   };

  static double _koef=-1;//=log(2*M_PI)/2;

  if (_koef < 0 ) _koef = log(2*M_PI)/2;
  int k;
  double s=0;
  double ex=z;
  for(k=1; k<=8; k++)
  {
    s+=bernulli[k-1]/ex;
    ex*=z*z;
  }
  s=s + _koef - z + (z-0.5)*log(z);
  return exp(s);
}
double Gamma(double z)
{
  //printf("(gamma(%f)",z);
  if(z>9.5)
    return AssimptGamma(z);
  else
  {
    //return Gamma(z+1)/z;
    int k=ceil(9.5-z);
    double m=1, g=AssimptGamma(z+k);
    z+=k;
    for(; k; k--)
    {
      z--;
      m*=z;
    }
    return g/m;
  }
}

fact_t fact(int x)
{
  if(x==0)return 1;
  fact_t m=x;
  while(--x)m*=x;
  return m;
}

