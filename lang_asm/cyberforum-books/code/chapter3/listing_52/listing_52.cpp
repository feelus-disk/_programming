//поиск максимального из трех чисел
#include <stdio.h>
void main()
{
int a,b,c;
	scanf("%d",&a);
	scanf("%d",&b);
	scanf("%d",&c);
	if(a>b)
	{
		if(a>c)printf("%d\n",a);
		else printf("%d\n",c);
	}else
	{
		if(b>c)printf("%d\n",b);
		else printf("%d\n",c);
	}
}
