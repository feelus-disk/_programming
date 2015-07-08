#include <stdio.h>
int add(int *, int, int);
void main()
{
	int i=10,s,j;
	s=12; j=20;
	printf("%d\n",add(&s,i,j));
};
int add(int * s1, int i1, int j1)
{
	int n;
	*s1=*s1+10;
	n=*s1+j1+i1;
	printf("%d\n",n);
return n*n;
};
