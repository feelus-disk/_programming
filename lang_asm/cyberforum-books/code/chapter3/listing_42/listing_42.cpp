#include <stdio.h>
#include <windows.h>
double myfunc(double, __int64, int, BYTE);
void main()
{
	double ff=10.45; 
	__int64 ii=1000; 
	int jj=200; 
	BYTE bb=50;
	double ss=myfunc(ff,ii,jj,bb);
	printf("%f\n",ff);
};
double myfunc(double f, __int64 i, int j, BYTE b)
{
	double s;
	s=f+i+j+b;
	printf("%f\n",s);
	return s;
};
