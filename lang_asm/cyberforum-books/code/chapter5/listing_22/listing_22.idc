#include <idc.idc>
static main()
{
	auto n,i,s;
	n=0;
	while(n!=-1)
	{	
		i=GetStrucId(n);
		s=GetStrucName(i);
		n=GetNextStrucIdx(n);
		Message("%x %s\n",i,s);
	}
}
