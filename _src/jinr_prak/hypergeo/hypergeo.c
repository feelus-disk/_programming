#include <stdio.h>
#include <math.h>
#include <float.h>
#include "../mycomplex.h"
#include "../gamma/gamma.h"

complex_t pohgammer(complex_t x, int n)
{
  if(!n) return complex(0,0);
  complex_t M=x;
  int i;
  for(i=1; i<n; i++)
    c_mulc(&M,*c_addc(&x,complex(1,0)));
  return M;
}
complex_t * next_pohgammer(complex_t * pm, complex_t x, int n)
{
  
}
complex_t F21_first_complex(complex_t a, complex_t b, complex_t c, complex_t z)
{
  complex_t S=complex(0,0);
  int n;
  complex_t 
    Ma=complex(1,0), 
    Mb=complex(1,0), 
    Mc=complex(1,0),
    zn=complex(1,0);
  double nf=1;
  for(n=0;;n++)
  {
    complex_t s=cmulc(cdivc(cmulc(Ma,Mb),Mc),cmulr(zn,1/nf));//n step
    if(dcabs(s)<0.000000000004)
      return caddc(S,s);
    c_addc(&S,s);
    nf*=n;
    //prepare to n+1 step
    c_mulc(&Ma,caddc(a,complex(n,0)));
    c_mulc(&Mb,caddc(b,complex(n,0)));
    c_mulc(&Mc,caddc(c,complex(n,0)));
    c_mulc(&zn,z);
  }
  //return S;
}
double F21_first_stupid(double a, double b, double c, double z)
{
  double S=0;
  int n;
  double 
    Ma=1,
    Mb=1,
    Mc=1,
    zn=1;
  double nf=1;
  //printf("S   s   Ma   Mb   Mc   zn   nf\n");
  for(n=0;;n++)
  {
    double s=Ma*Mb/Mc*(zn/nf);//n step
    if(fabs(s)<0.04)
      return S+s;
    S+=s;
    //printf("%lg %lg %lg %lg %lg %lg %lg",S,s,Ma,Mb,Mc,zn,nf);
    //getchar();
    //prepare to n+1 step
    nf*=(n+1);//(n?n:1);
    Ma*=a+n;
    Mb*=b+n;
    Mc*=c+n;
    zn*=z;
  }
  //return S;
}
double F21_first(double a, double b, double c, double z)
{
  const int N_MAX=1000000;
  //printf("(F21_f(%f)",z);
  double S=0;
  int n;
  double body=1;
  //printf("S   s   body\n");
  for(n=0;n<N_MAX;n++)
  {
    //    double s=body;//n step
    if(fabs(body)<DBL_EPSILON*(1+fabs(S)))
    {
      //printf("=%f)",S+body);
      return S+body;
    }
    S+=body;
    //printf("%lg %lg %lg",S,s,body);
    //getchar();
    //prepare to n+1 step
    body/=(n+1);//(n?n:1);
    body*=a+n;
    body*=b+n;
    body/=c+n;
    body*=z;
  }
  printf(" F21_series out of %d iteration\n",N_MAX);
  return S;
}

double F21log_c(double x)
{  return dcabs(F21_first_complex(complex(1,0),complex(1,0),complex(2,0),complex(1-x,0)))*(x-1);    }
double F21asin_c(double x)
{  return dcabs(F21_first_complex(complex(0.5,0),complex(0.5,0),complex(1.5,0),complex(x*x,0)))*x;  }

typedef double (*dd_fun)(double);
void testprint(double low, double step, double high, dd_fun f1, dd_fun f2, char * f1name, char * f2name)
{
  printf("\n\n    z  %20s  %20s      delta_rel\n",f1name,f2name);
  double z;
  for(z=low; z<=high; z+=step)
  {
    double ff1=f1(z);
    double ff2=f2(z);
    printf("%5.2g  %20.15g  %20.15g  %10g\n",z,ff1,ff2,(ff1-ff2)/fabs(ff1));
  }
}


double F21log(double x)
{  return F21_first(1,1,2,1-x)*(x-1);    }
double F21asin(double x)
{  return F21_first(0.5,0.5,1.5,x*x)*x;  }
double F21_112(double x)
{  return F21_first(1,1,2,x);  }
double mzm1ln1_z(double x)
{  return -log(1-x)/x;  }

//double Gamma(double z);//defined in ../gamma/gamma.c

double F21(double a, double b, double c, double z)
{
  //  printf("(F21(%f)",z);
  if(z>1)
  {
    //    printf("/>1/=%f)",0./0.);
    return 0./0.;
  }
  if(fabs(1-z)<DBL_EPSILON)
  {
    double rez=Gamma(c)*Gamma(c-a-b)/(Gamma(c-a)*Gamma(c-b));
    //    printf("/==1/=%f)",rez);
    return rez;
  }
  if(z>0.5)
  {
    double rez= Gamma(c)*Gamma(c-a-b)/(Gamma(c-a)*Gamma(c-b))*F21_first(a,b,a+b-c+1,1-z)+
      pow(1-z,c-a-b)*Gamma(c)*Gamma(a+b-c)/(Gamma(a)*Gamma(b))*F21_first(c-a,c-b,c-a-b+1,1-z);
    //    printf("/>0.5/=%f)",rez);
    return rez;
  }
  if(z<-0.5)
  {
    double rez= pow(1-z,-a)*F21(a,c-b,c,z/(z-1));
    //    printf("/<-0.5/%f)",rez);
    return rez;
  }
  {
    double rez= F21_first(a,b,c,z);
    //    printf("/def/%f)",rez);
    return rez;
  }
}
double F21_atan(double z)
{  return F21(0.5,1,1.5,-z*z);  }
double atanz(double z)
{  return atan(z)/z;  }

double F21_sqrts(double z)
{  return F21(-0.25,0.25,0.5,-z*z);  }
double sqrts(double z)
{  return (sqrt(sqrt(1+z*z)+z)+sqrt(sqrt(1+z*z)-z))/2;  }
int main()
{
  //  printf("hello");
  //  double nf=1;
  //  nf*=1;
  //  printf("%f",nf);
  //  getchar();
  //  testprint( 0.05,0.1,0.95,F21log ,log ,"F21log","log");
  //testprint( 0.05,0.1,0.95,F21_112 ,mzm1ln1_z ,"F21_112","qwerrewqewq");
  //testprint(-0.95,0.1,0.95,F21asin,asin,"F21asin","asin");
  
  testprint(0,0.05,0.7,F21_atan,atanz,"F21_atan","atanz");
  testprint(0.7,0.1,1,F21_atan,atanz,"F21_atan","atanz");
  testprint(1,0.5,10,F21_atan,atanz,"F21_atan","atanz");

  testprint(0,0.05,0.7,F21_sqrts,sqrts,"F21_sqrts","sqrts");
  testprint(0.7,0.1,1,F21_sqrts,sqrts,"F21_sqrts","sqrts");
  testprint(1,0.5,10,F21_sqrts,sqrts,"F21_sqrts","sqrts");

  return 0;
}
