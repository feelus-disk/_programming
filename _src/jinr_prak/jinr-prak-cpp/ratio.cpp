#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <randomize.h>
#include <set>
using std::set;
#include <algorithm>
using std::swap;
#include <math.h>

typedef long long int llint;

#define _num numerator
#define _denum denumerator
class ratio
{
public:
  llint numerator, denumerator;
  ratio()  :_num(0),_denum(1)  {}
  //copy-constructor & operator= - default
  ratio(llint num, llint denum)  :_num(num),_denum(denum)
  {  normalize();  }
  ratio(llint num)  :_num(num),_denum(1)  {}
  //  ratio(double x){}

  ratio & normalize();
  ratio & denormalize(llint x)
  {  _num*=x;  _denum*=x;  return *this;  }
  ratio & scan(FILE * f=stdin)
  {  fscanf(f,"%lld/%lld",&_num, &_denum);  normalize();  return *this;  }
  ratio & print(FILE * f=stdout)
  {  fprintf(f,"%lld/%lld",_num,_denum);  return *this;  }
  
  ratio & invert()  {  swap(_num,_denum);  return *this;  }
  bool operator==(const ratio & x) const
  {  return _num==x._num && _denum==x._denum;  }
  bool operator<(ratio x) const;

  operator double ()const
  {  return (double)_num/_denum;  }
};

void _euclid(llint * pi1, llint * pi2)
{
  while(*pi2){
    llint tmp=*pi1;
    *pi1=*pi2;
    *pi2=tmp%*pi2;
    //printf("%lld %lld\n",*pi1,*pi2);
  }
  
}
inline
llint euclid(llint a, llint b)
{
  _euclid(&a,&b);
  return a;
}
ratio & ratio::normalize()
{
  if(denumerator<0)  {  numerator*=-1;  denumerator*=-1;  }
  llint x=euclid(numerator, denumerator);
  numerator/=x;
  denumerator/=x;
}
void denormalize(ratio * x, ratio * y)
{
  llint tmp=x->_denum, nok=euclid(x->_denum,y->_denum);
  x->denormalize(y->_denum/nok);
  y->denormalize(tmp/nok);
}
bool ratio::operator<(ratio x)const
{
  ratio l=*this;
  ::denormalize(&l,&x);
  return l._num<x._num;
}
#undef _num
#undef _denum

void testnormalize()
{
  ratio x;
  printf("enter numerator/denumerator\n");
  x.scan();
  printf("normalized form is:\n");
  x.print();
}
void testdenormalize()
{
  //printf("===testdenormaliz===\n");
  ratio x,y;
  printf("enter numerator/denumerator for x and y\n");
  x.scan();y.scan();
  denormalize(&x,&y);
  x.print();printf(" ");y.print();printf("\n");
}
void testcompare()
{
  ratio x,y;
  printf("enter numerator/denumerator for x and y\n");
  x.scan();y.scan();
  x==y ? printf("x == y\n") :
    x<y ? printf("x < y\n") : printf("x > y\n");
}

int ratioset(llint max)
{
  set<ratio> ratioset;
  for(llint d=1; d<max; d++)
    for(llint n=1; n<max; n++)
      ratioset.insert(ratio(n,d));
  return ratioset.size();
}
void test_rs(char * argv[])
{
  int m=atoi(argv[1]);
  printf("%d%%",ratioset(m)*100/m/m);
}
#if 0
inline
int round_p(double x)
{
  double i;
  if(modf(x,&i)>=0.5)
    i++;
  return i;
}
#endif
void doubletoratio(double x, double eps)
{
  double d1=x-round(x);
  int curdenum=1;
  double dc;
  printf("--- %10g ---\n",d1);
  while(fabs(dc=x*curdenum-round(x*curdenum))>eps){
    printf("%+-15g   %d/%d\n",dc,(int)round(x*curdenum),curdenum);
    curdenum+=round((1-dc)/d1);
  }
    
  printf("=======\n%10g   %d/%d\n",dc,(int)round(x*curdenum),curdenum);
}

void test_dr()
{
  //printf("RAND_MAX=%d\n",RAND_MAX);//getchar();
  randomize();
  int num=rand(), denum=rand();
  num%=10000; denum%=10000;
  //ratio x(num,denum);
  ratio x(1,3);
  x.print();printf("===\n");
  getchar();
  doubletoratio((double)x,0.000000001);
}

int main(int argc, char * argv[])
{
  test_dr();
  llint a,b;
  //a=atoi(argv[1]);
  //b=atoi(argv[2]);
  //testdenormalize();
}
