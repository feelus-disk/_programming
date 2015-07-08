#include <stdio.h>
#include <windows.h>
void main()
{
	DWORD a,b,c;
	scanf("%d",&a);
	scanf("%d",&b);
	c=((a+b)/8)*(3*a);
	printf("%d\n",c);
};
