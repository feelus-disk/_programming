#include <stdio.h>
#include <stdlib.h>
int  a, b=20; 
int * s;
void main()
{
	s=(int*)malloc(4);
	a=10;
	*s=a+b;
	printf("%d",*s);
	free(s);
};
