#include <stdio.h>
void main()
{
	int a[100];
	int i=0,s=0;
	for(i=0; i<100; i++)a[i]=i;
	for(i=0; i<100; i++)s+=a[i];
	printf("%d\n",s);
}
