#include <stdio.h>
#include <windows.h>
double s,d;
int i;
void main()
{
	s=0.00;
	d=1.034;
	for(i=0; i<100; i++)
		s=s+i/d;
    printf("%f\n",s);
};
