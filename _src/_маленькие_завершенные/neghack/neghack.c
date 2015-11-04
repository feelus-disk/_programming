#include <stdio.h>
int main()
{
  char c=-128;
  printf("-128=%d\n",c);
  char d=-c;
  c=-c;
  printf("-(-128)=%d\n",d);
  return 0;
}
