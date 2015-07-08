#include <idc.idc>
static main() 
{
auto ad;
ad=0x401020;
	while(ad<=0x401041)
	{
		Message("%x\n",ad);
		ad=NextAddr(ad);
	};
}
