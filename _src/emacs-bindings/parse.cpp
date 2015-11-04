#include <stdio.h>
#include <map>
using std::map;
using std::multimap;
#include <set>
using std::set;
#include <list>
using std::list;
#include <string>
using std::string;
#include <string.h>

using std::pair;
using std::make_pair;

int main(int argc, char * argv[])
{
	if(argc!=2)	{	printf("usage parse file\n"); exit(1);	}
	FILE * f=fopen(argv[1],"r");
	if(!f)	{	printf("can not open file %s",argv[1]);	exit(1);	}
	
	list<string> ls;
	char s[10000];//не жмемся
	while(fgets(s,10000,f))
		if(length(s))
			ls.push_back(s);
	fclose(f);
	
	
	
	typedef list<string>::iterator LsIt;
	for(LsIt it=ls.begin; it!=ls.end(); it++)
	{
		for(char * pc=it->c_str(); *pc; pc++)
			if(*pc!=' ' || *pc!='\t' || *pc!='-')
				goto m1;
		goto m2;
		m1:	continue;
		m2:
		LsIt dd1, dd2;
		if(it==ls.begin() || (dd1=advance(it,-1))==ls.begin() )	{printf("before ----- empty"); exit1;	}
		dd2=advance(it,-2);
		ls.erase(dd1);
		ls.erase(it);
		it=dd2;
		
	}
}












