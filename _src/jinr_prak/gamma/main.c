#include "gamma.h"
int main()
{
  //_koef=log(2*M_PI)/2;
  printf("-----------------------------\n");
  
  printf("G(10)=%20.15f\n",Gamma(10));
  printf("G(1/2)=%20.18f\n",Gamma(1./2));

  printf(" n                    n!            Gamma(n+1)    Gamma(n+1)-n!\n");
  for(i=1; i<35; i++)
  {
    fact_t f=fact(i);
    double g=Gamma(i+1);
    printf("%2d  %20.14g  %20.14g  %10.1e\n",i,f,g,g-f);
  }

  printf("\n\n    z           G(z)*G(1-z)          pi/sin(pi*z)  G(z)*G(1-z)-pi/sin(pi*z)\n");
  double z;
  for(z=-0.95; z<=0.95; z+=0.1)
  {
    double gg=Gamma(z)*Gamma(1-z);
    double spz=M_PI/sin(M_PI*z);
    printf("%5.2f  %20.15f  %20.15f  %10.1e\n",z,gg,spz,gg-spz);
  }
  return 0;
}
