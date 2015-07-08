#include <stdio.h>
#include <windows.h>
int k=0x1667;
BYTE  *b=(BYTE*)&k;
void main()
{
	int j=0;
	printf("\n%p   ",b);
	for(int i=0; i<400; i++)
	{
		printf("%02x  ",*(b++));
		if(++j==16&&i<398){
			printf("\n"); 
			j=0;
			printf("%p   ",b);
		};
	};
	printf("\n");
};
