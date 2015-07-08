#include <idc.idc>
static main()
{
	auto ad,s;
	ad=0x401000;
	while(ad<=0x4030bc)
	{
		if(GetMnem(ad)=="push" 	&&
		GetMnem(NextHead(ad,BADADDR))=="push" &&
		GetMnem(NextHead(NextHead(ad,BADADDR),BADADDR))=="push"
		)		
		{
//перевести курсор по найденному адресу
			Jump(ad);		
//выход из цикла
			break;		
		}
		ad=NextHead(ad,BADADDR);				
	}
}
