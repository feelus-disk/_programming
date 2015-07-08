#include <stdio.h>
class A {
public:
	int a;
	int seta(int a1){a=a1; return a;};
	void pa(){printf("%d\n",a);}
};
class B:public A {
public:
	int seta(int a1){a=a1+1; return a;};
};
void main()
{
	A* A1;
	A1=new(B);
	A1->seta(10);
	A1->pa();
	delete A1;
};
