#include <stdio.h>
#include <stdlib.h>

int main()
{
  printf("before system mkfifo fofo\n");
  system("mkfifo fofo");
  printf("after system mkfifo fofo\n");

  printf("before fopen\n");
  FILE * f=fopen("fofo","r");
  printf("after fopen\n");

  if(!f){  printf("cannot open fofo\n"); exit(1); }

  printf("before system echo 123 > fofo &\n");
  system("echo 123 > fofo &");
  printf("after system echo 123 > fofo &\n");
  char s[10000];
  fgets(s,10000,f);
  printf("%s\n",s);
}
