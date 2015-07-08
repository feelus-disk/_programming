#include <idc.idc>
static main()
{
	auto ad,s,i;
	ad=0x401000;
	while(ad<=0x4030bc)
	{
		s=GetFunctionName(ad);
		Message("%s\n",s);
		i=GetFunctionFlags(ad);
		if(i & FUNC_LIB)
		{
			SetFunctionCmt(ad,"Это библиотечная функция",1);
		}
		ad=NextFunction(ad);				
	}
}
