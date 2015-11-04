#include <stdio.h>
#include <algorithm>

struct sost
{
	int size,x,y,z;
	int * array;
	bool operator<(const sost & r)
	{
		return std::lexicographical_compare(array,array+size,...);
	}
};

int main()
{
	return 0;
}