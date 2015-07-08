#include <stdio.h>
#include <windows.h>
struct a {
char s[10];
	BYTE b;
	int i;
};
a a1;
void main()
{
	for(int j=0; j<10; j++) a1.s[j]='A';
	a1.b=10;
	a1.i=10000;
};
