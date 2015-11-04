#include <stdio.h>
#include <istream>
#include "stralgorithm.h"
#include "str.h"
#include "mystream.h"
using namespace str;
int main(int argc, char * argv[])
{	
	if(err)
	{
		printf("%s",err);
		getchar();
	}
	else
		printf("hello!");
	//getchar();
	return 0;
}