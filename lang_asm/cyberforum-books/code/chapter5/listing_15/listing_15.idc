#include <idc.idc>
static main()
{
	auto ad,i,j;
	ad=0x4055d6;
	while(ad<=0x405Aff)
	{
		ad=NextHead(ad,BADADDR);
//вывести адрес инструкции
		Message("%10x ",ad);
//получить флаг
		i=GetFlags(ad);
//проверка Ц €вл€ютс€ ли это данные
		if(((i & MS_CLS) == FF_DATA))
		{
			Message("Data: size - %d, type - ",ItemSize(ad),i);
			if((i & 0xF0000000) == FF_BYTE)
			{
				Message("byte\n");
				continue;
			}
			if((i & 0xF0000000) == FF_WORD)
			{
				Message("word\n");
				continue;
			}
			if((i & 0xF0000000) == FF_DWRD)
			{
				Message("dword\n");
				continue;
			}
			if((i & 0xF0000000) == FF_QWRD)
			{
				Message("qword\n");
				continue;
			}
			if((i & 0xF0000000) == FF_TBYT)
			{
				Message("tbyte\n");
				continue;
			}
			if((i & 0xF0000000) == FF_ASCI)
			{
				Message("string ASCII\n");
				continue;
			}
			if((i & 0xF0000000) == FF_STRU)
			{
				Message("structure\n");
				continue;
			}
			if((i & 0xF0000000) == FF_OWRD)
			{
				Message("octaword\n");
				continue;
			}
			if((i & 0xF0000000) == FF_FLOAT)
			{
				Message("float\n");
				continue;
			}
			if((i & 0xF0000000) == FF_DOUBLE)
			{
				Message("double\n");
				continue;
			}
			if((i & 0xF0000000) ==  FF_PACKREAL)
			{
				Message("packed decimal real\n");
				continue;
			}
			if((i & 0xF0000000) == FF_ALIGN)
			{
				Message("align\n");
				continue;
			};
			Message("??\n");
			
		}
		else
			Message("?\n");
	}
}
