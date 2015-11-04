#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <vector>
using std::vector;
#include <map>
using std::map;
#include <string>
using std::string;
#include <utility>//pair
using std::pair;
using std::make_pair;

#define ifnot(x) if(!(x))

//read not void_string_before_chars or end string
bool read_string_before_chars(char * * ps,string * str,char * pattern)
{
	if(**ps==0 || **ps=='\r' || **ps=='\n' )	return false;
	char * f=strpbrk(*ps,pattern);
	ifnot(f) f=*ps+strlen(*ps)-1;//סףלאסרוהראÿ במנüבא סמ \r
	str->clear();
	while(*ps!=f)
		str->push_back(*(*ps)++);
	return true;
}
bool readconststr(char * * ps, char * s)
{
	while(*s)
		if(*(*ps)++!=*s++)	return false;
	return true;
}

struct stru{
	int N;
	vector<pair<string,int>> refs;
};

void print_graph(const map<string,stru> * G)
{
	printf("---------------------\n");
	for(map<string,stru>::const_iterator im=G->begin(); im!=G->end(); im++)
		for(vector<pair<string,int>>::const_iterator iv=im->second.refs.begin(); iv!=im->second.refs.end(); iv++)
			printf("%s(%d)-> %s(%d)\n",im->first.c_str(),im->second.N,iv->first.c_str(),iv->second);
	getchar();
}

int main(int argc, char * argv[])
{
try
{
	FILE * f= fopen("../requirements_stac.txt","r");
	if(!f)	throw "cannot open file";
	
	map<string,stru> graph;
	int line=0, count=0;;

	while(true)
	{
		char s[1000];
		if(feof(f)) break;
			fgets(s,1000,f);line++;	
		char * p=s;
	string str;
		ifnot(read_string_before_chars(&p,&str,"\t"))	break;

		if(feof(f)) throw "eof";
			fgets(s,1000,f);line++;
		
		if(feof(f)) throw "eof";
			fgets(s,1000,f);line++;
		p=s;
		ifnot(readconststr(&p,"\tRequired by: "))	throw "can't read 	\"Required by:\" ";
	stru tru; count++;
		tru.N=count;
		printf("==== %s(%d) =====\n",str.c_str(),tru.N);
		string tempstr;
		while(read_string_before_chars(&p,&tempstr,",\r"))
		{
			tru.refs.push_back(make_pair(tempstr,0));
			if(*p) p++;
			if(*p) p++;
			printf("%s : ",tempstr.c_str());
		}
		printf("\n");
		graph.insert(graph.begin(),make_pair(str,tru));
		//print_graph(&graph);

		if(feof(f)) break;
			fgets(s,1000,f);line++;
	}
	fclose(f);
	print_graph(&graph);

	for(map<string,stru>::iterator im=graph.begin(); im!=graph.end(); im++)
		for(vector<pair<string,int>>::iterator iv=im->second.refs.begin(); iv!=im->second.refs.end(); iv++)
		{
			printf("finding %s\n",iv->first.c_str());
			map<string,stru>::iterator tmp=graph.find(iv->first);
			if(tmp==graph.end())
			{
				print_graph(&graph);
				throw "can't find key";
			}
			iv->second=tmp->second.N;
			//print_graph(&graph);
		}
	f=fopen("../graph.tgf","w");
	for(map<string,stru>::iterator im=graph.begin(); im!=graph.end(); im++)
		fprintf(f,"%d %s\n",im->second.N,im->first.c_str());
	fprintf(f,"#\n");
	for(map<string,stru>::iterator im=graph.begin(); im!=graph.end(); im++)
		for(vector<pair<string,int>>::iterator iv=im->second.refs.begin(); iv!=im->second.refs.end(); iv++)
			fprintf(f,"%d %d\n",iv->second,im->second.N);
	fclose(f);
}catch(char * s)
{
	printf("%s",s);
	getchar();
	exit(1);
}
	return 0;
}