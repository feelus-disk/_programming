#include <idc.idc>
static main()
{
	auto ad,i,j;
	ad=0x401000;
	while(ad<=0x401042)
	{
//операнды представить в шестнадцатеричном виде
		OpHex(ad,-1);
//вывести адрес инструкции
		Message("%10x ",ad);
//получить типы операндов
		i=GetOpType(ad,0);
		j=GetOpType(ad,1);
//вывести имя инструкции
		Message("%s ",GetMnem(ad));
		if(i>0)
		{
//вывести первый операнд (если он есть)
			Message("%s",GetOpnd(ad,0));
			if(j>0)
			{
//вывести второй операнд (если он есть)
				Message(",%s \n",GetOpnd(ad,1));
			}else 
				Message("\n");
		}else 
			Message("\n");
//перейти к адресу следующей инструкции
		ad=NextHead(ad,BADADDR);
	}
}
