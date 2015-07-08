/*prg14_21.c*/
#include <stdio.h>
extern	int	sum_asm(int massiv[],int count);
main()
{
	int	mas[5]={1,2,3,4,5};
	int	len=5;
	int sum;
	sum=sum_asm(mas,len);
	printf('%d\n',sum);
	return(0);
}

