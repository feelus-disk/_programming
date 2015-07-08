#include <stdio.h>
wchar_t  s[]=L"Hello, programmer!";
wchar_t  f[]=L"%s\n";
void main()
{
    wprintf(f,s);
};
