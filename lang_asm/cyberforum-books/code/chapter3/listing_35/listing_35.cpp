#include <stdio.h>
int __fastcall  add(int, int , int);
void main()
{
	int i=10,j=20,k=30;
	printf("%d\n",add(i,j,k));
};

int __fastcall add(int a, int b, int c)
{
	return a+b+c;
};
