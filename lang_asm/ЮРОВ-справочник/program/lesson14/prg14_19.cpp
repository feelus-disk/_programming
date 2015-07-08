//prg14_19.cpp
#include<conio.h>
extern void asmproc(char ch, unsigned x,
unsigned y,unsigned kol);
void main (void)
{
clrscr();
asmproc('a', 2, 3, 5);
asmproc('s', 9, 2, 7);
}

