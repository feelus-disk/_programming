#include <idc.idc>

static main() 
{
auto ad,i;
	for(ad=0x401020; ad<=0x401041; ad++)
	{
		Message("%x........",ad);
		if(GetFlags(ad) & FF_IVL)
		{
//печатаем значение прочитанного байта
			i=Byte(ad);
			if(i>31)			
			Message("%x...%c\n",i,i);
			else
			Message("%x...\n",i);
		}else
		{
//значение байта не определено
			Message("Error!\n");
		}
	}
}
