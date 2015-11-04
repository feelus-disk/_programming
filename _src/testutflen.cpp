#include <stdio.h>
//#define UTFLEN_DEBUG
#include <utflen.h>
int main(int argc, char * argv[]){
  if(argc==2)
    printf("%d\n",utflen(argv[1]));
}
  
