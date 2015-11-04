#include <stdio.h>
#include <locale.h>
#include <algorithm>
int main()
{
	setlocale(LC_ALL, "RUS");
	char x[10], *src="נובכאםüהמ";
	std::copy(src,src+10,x);
	std::sort(x,x+10);
	while(true)
	{
		printf("%s",x);
		getchar();
		std::next_permutation(x,x+9);

	}
}