#include <stdio.h>
char * s="Example of console program.\n\0";
char buf[100];
void main()
{
	puts(s);
	gets(buf);
}
