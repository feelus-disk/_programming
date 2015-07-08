#include <idc.idc>

static main() 
{
auto ad,i,j;
j=0x91;
	for(ad=0x401020; ad<=0x401041; ad++)
	{
		if(GetFlags(ad) & FF_IVL)
		{
			i=Byte(ad);
			if(i==0x50)PatchByte(ad,j); 			
		}
	}
}
