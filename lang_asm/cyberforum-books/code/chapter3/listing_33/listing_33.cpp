#include <stdio.h>
void main()
{
int i,j,s;
	i=0; j=1; s=0;
	for(i=0; i<100; i++,j++)s=s+j;
	printf("%d %d %d \n",i,j,s);
};
