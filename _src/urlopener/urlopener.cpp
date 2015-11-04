#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

void upperstring(char * s)
{
  while(*s)
    *s=toupper(*s), s++;
}
void readspaces(char ** ps)
{
  char ch;
  while(isspace(*(*ps)))(*ps)++;
}
bool read_const_str_caseinsens(char ** const ps, const char * s)
{
  while(*s && **ps)
  {
    char u=toupper(*(*ps));
    char l=tolower(*(*ps));
    if(u!=*s && l!=*s)
      return false;
    (*ps)++;
    s++;
  }
  return true;
}
int main(int argc, char * argv[])
{
  if(argc<2)
  {
    fprintf(stderr,"first argument must be name of url file\n");
    return 1;
  }
  FILE * f=fopen(argv[1],"r");
  if(!f)
  {
    fprintf(stderr,"cannot open file '%s'\n",argv[1]);
    return 1;
  }
  char s[1000];
  while(fgets(s,1000,f))
  {
    char * ps=s;
    //    upperstring(s);
    readspaces(&ps);
    if(!read_const_str_caseinsens(&ps,"URL"))
      continue;
    readspaces(&ps);
    if(*ps++!='=')
      continue;
    readspaces(&ps);
    char invs[5000];
    strcpy(invs,"firefox ");
    strcpy(invs+8,ps);
    system(invs);
    return 0;
  }
  fprintf(stderr,"cannot find 'url =' or 'URL=' in file '%s'\n",argv[1]);
  return 1;
}
