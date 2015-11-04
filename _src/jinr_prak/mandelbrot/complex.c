#include <stdio.h>
#include <math.h>
#include <stdlib.h>
//#include <conio.h>
int i;//for for(int i...)

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
int print_complex(complex_t X)
{
  int c=0;
  c+=printf("(%f,%f)",X.re,X.im);
  return c;
}
int enter()
{ return printf("\n"); }
complex_t cadd(complex_t a, complex_t b)
{
  a.re+=b.re;
  a.im+=b.im;
  return a;
}
complex_t cneg(complex_t a)
{
  a.re=-a.re;
  a.im=-a.im;
  return a;
}
complex_t cmul(complex_t a, complex_t b)
{
  complex_t r;
  r.re=a.re*b.re-a.im*b.im;
  r.im=a.re*b.im+a.im*b.re;
  return r;
}
complex_t cmulr(complex_t a, double b)
{
  a.re*=b;
  a.im*=b;
  return a;
}
double c_abs(complex_t x)
{ return sqrt(x.re*x.re+x.im*x.im);   }
double c_arg(complex_t x)
{ return atan2(x.im,x.re);   }
complex_t cconj(complex_t x)
{
  x.im=-x.im;
  return x;
}
void cconjun(complex_t * px)
{ px->im=-px->im;  }



int cabs_cmp(const complex_t * lp, const complex_t * rp)
{  return c_abs(*lp)-c_abs(*rp);    }
void test()
{
  complex_t a=complex(1,2);
  print_complex(a);enter();

#define N 6
  complex_t m[N];
  m[0]=complex(43,45);
  m[1]=complex(43,56);
  m[2]=complex(34,90);
  m[3]=complex(89,1);
  m[4]=complex(1,22);
  m[5]=complex(23,22);
  for(/*int*/i=0; i<N; i++)
    print_complex(m[i]), printf("  ");
  enter();
  qsort(m,N,sizeof(complex_t),cabs_cmp);
  for(/*int*/i=0; i<N; i++)
    print_complex(m[i]), printf("  ");
  enter();
}

double radius=2;
int maxcount=10000;
int isInMandelbrot(complex_t C)
{
  complex_t z=complex(0,0);
  int cnt=0;
  while(c_abs(z)<radius && ++cnt<maxcount)
    z=cadd(cmul(z,z),C);
  //  print_complex(C);printf(" - %d",cnt);
  //getchar();
  return cnt;
}
void print_Mandelbrot(complex_t line_c, complex_t ReStep, complex_t ImStep, int scrX, int scrY, FILE * file, int enters)
{
  int line,col;
  complex_t col_c;
  line_c=cadd(line_c,cmulr(ReStep,0.5));
  line_c=cadd(line_c,cmulr(ImStep,0.5));
  for(line=1, line_c; line<=scrY; line++, line_c=cadd(line_c,ImStep))
  {
    for(col=1, col_c=line_c; col<=scrX; col++, col_c=cadd(col_c,ReStep))
      if(isInMandelbrot(col_c)>maxcount-1)
	fprintf(file,"*");
      else
	fprintf(file," ");
    if(enters)
      fprintf(file,"\n");
  }
}

int main()
{
  //test();
  //printf("hello\n");
  int scrX=79, scrY=30;
  double ss=0.75;
  complex_t 
    pos=complex(-2,-1),
    ReStep=complex(3/(double)scrX,0),
    ImStep=complex(0,ss*c_abs(ReStep)*scrX/scrY);
  while(1)
  {
    print_complex(pos);
    print_complex(
		  cadd(
		       pos,
		       cadd(
			    cmulr(ReStep,scrX),
			    cmulr(ImStep,scrY))));
    enter();
    print_Mandelbrot(pos,ReStep,cneg(ImStep),scrX,scrY,stdout,1);
  sw:
    switch(getchar())
    {
    case '=':cmulr(ImStep,1.1);cmulr(ReStep,1.1);break;
    case '-':cmulr(ImStep,1./1.1);cmulr(ReStep,1./1.1);break;
    case 'w':pos=cadd(pos,ImStep);break;
    case 'a':pos=cadd(pos,cneg(ReStep));break;
    case 's':pos=cadd(pos,cneg(ImStep));break;
    case 'd':pos=cadd(pos,ReStep);break;
    case 'z':
      switch(getchar())
      {
      case 'x':scanf("%d",&scrX);break;
      case 'y':scanf("%d",&scrY);break;
      case 's':scanf("%f",&ss);
	ImStep=complex(0,ss*c_abs(ReStep)*scrX/scrY);
      };break;
    case 'h':
      printf("= увеличить\n");
      printf("- уменьшить\n");
      printf("wasd перемещение\n");
      printf("zx %%d количество символов по горизонтали\n");
      printf("zy %%d количество символов по вертикали\n");
      printf("zs %%f соотношение сторон экрана\n");
    default: goto sw;
    }
  }
  return 0;
}
//.!&*#
