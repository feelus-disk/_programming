#include <stdio.h>
#include <windows.h>
struct a {
	char s[10];
	BYTE b;
	int i;
};
a a1;
void init(a);
void main()
{
	init(a1);
};
void init(a c)
{
	for(int j=0; j<10; j++) c.s[j]='A';
	c.b=10;
	c.i=10000;
};
