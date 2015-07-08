#include <stdio.h>
int add(int, int);
int sub(int, int);
void main()
{
	int i=10,j=20;
	printf("%d\n",add(i,sub(i,j)));
};

int add(int a, int b)
{
	return a+b;
};
int sub(int a, int b)
{
	return a-b;
};
