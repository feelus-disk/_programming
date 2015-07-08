#include <stdio.h>
#include <windows.h>

int main()
{
	int a,b;
	scanf("%d",&a);
	scanf("%d",&b);
	__try	{
		a=a/b;
		printf("%d\n",a);
	}
	__except(0)
	{
		printf("Error 1! \n");
	};
	return 0;
}
