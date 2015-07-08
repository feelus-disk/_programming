#include <stdio.h>
class A {
public:
	int a;
	virtual void pa(){printf("%d\n",a);}
	A(){a=1; printf("Constructor A\n");};
	~A(){printf("Destructor A\n");};
};
void main()
{
	A* A1;
	A1=new(A);
	A1->pa();
	delete A1;
};
