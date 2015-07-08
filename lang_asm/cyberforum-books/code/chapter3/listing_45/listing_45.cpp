#include <stdio.h>
#include <string.h>
int getpassword(char *);
char * passw="privet";
int main()
{
	printf("Input password:\n");
	if(!getpassword(passw))printf("You are registered!\n");
	else printf("You are wrong!\n");
	return 0;
};

int getpassword(char * ss)
{
	char s[13];
	gets(s);
	if(!strcmp(s,ss))return 0;
	else return 1;
}
