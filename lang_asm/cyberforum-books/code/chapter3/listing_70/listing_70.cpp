#include <stdio.h>
class A {
public:
	int b;
	int a;
	int geta(){b=0; return a;};
	void seta(int);
};
void A::seta(int a1)
{
	a=a1;
	b=1;
};
A A1;
void main()
{
	A1.seta(10);
	int c=A1.geta();
	printf("%d\n",c);
}
