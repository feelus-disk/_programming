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
void main()
{
	A * A1=new(A);
	A1->seta(10);
	int c=A1->geta();
	printf("%d\n",c);
	delete A1;
}
