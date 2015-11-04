//#1788330 попробовать long long
#include <stdio.h>
#include <math.h>

int main()
{
  unsigned int _case=0;
  while(true) {
    _case++;
    unsigned int N;
    scanf("%d\n",&N);
    if(!N) return 0;
    unsigned int s=0;
    unsigned int n=0;
    for(unsigned int d=2; d<=sqrt(N+1); d++) {
      unsigned int m=1;
      while(N%d==0) {
	N/=d;
	m*=d;
      }
      if(m>1) { s+=m; n++; }
    }
    if(N>1)  { s+=N; n++; }
    if(n==1) s++;
    if(n==0) s=2;
    printf("Case %d: %d\n",_case,s);
  }
}
