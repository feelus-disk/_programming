#include <stdio.h>
#include <map>
using namespace std;
int main()
{
  map<int,int> mas;
  int min=0, sec=0;
  char s[10000];
  int line=0;
  while(!feof(stdin)) {
    line++;
    gets(s);
    line++;
    int lmin, lsec;
    if(2!=scanf("%d:%d\n",&lmin,&lsec)) {
      fprintf(stderr,"error on line %d\n",line);
      return 1;
    }
    mas.insert(make_pair(lmin+60*lsec,line));
    min+=lmin;
    sec+=lsec;
  }
  min+=sec/60;
  sec%=60;
  int hour=min/60;
  min%=60;
  printf("total %d:%d:%d\n",hour,min,sec);
  int i=0;
  for(map<int,int>::iterator it=--mas.end(); it!=mas.begin() && i<20; it--, i++)
    printf("%d : %d:%d\n",it->second,it->first/60,it->first%60);
  // map<int,int>::iterator it=mas.begin();
  // printf("%d : %d:%d\n",it->second,it->first/60,it->first%60);
}
