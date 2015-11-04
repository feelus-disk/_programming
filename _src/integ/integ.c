#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

double drand()
{  return (double)rand();  }
double rand1()
{  return drand()/RAND_MAX;  }
double rand2()
{  return (drand()*RAND_MAX+drand())/RAND_MAX/RAND_MAX;  }
double rand3()
{  return (drand()*RAND_MAX*RAND_MAX+drand()*RAND_MAX+drand())/RAND_MAX/RAND_MAX/RAND_MAX;  }
#define rand rand3

void printusage()	{
	printf("usage: integ a b d [N]\n");
}
int main(int argc, char * argv[])	{
	double a,b,d;
	if(argc!=4 && argc!=5)	{
		printusage();
		exit(1);
	}	else	{
		a=atof(argv[1]);
		b=atof(argv[2]);
		d=atof(argv[3]);
	}
	
	int N=1000000;
	if(argc==5)
		N=atoi(argv[4]);
		
	{
	time_t t;
	srand(time(&t));
	}
	
	int n=0, i;
	for(i=0; i<N; i++)	{
		double xb, yb, xt, yt, tt, fi;
		xb=rand()*a;		
		yb=rand()*b;		
		fi=rand()*M_PI*2;	
		{
			double x;
			do	{
				x=rand();
				tt=rand()*M_PI/2;
			}	while(x>sin(tt));
		}					
		xt=xb+d*tan(tt)*cos(fi);		
		yt=yb+d*tan(tt)*sin(fi);		
		
		if(xt>0 && yt>0 && xt<a && yt<b)
			n++;
		if(0){
		double r=tan(tt)*d;				
		printf("xb=%f\n",xb);
		printf("yb=%f\n",yb);
		printf("fi=%f\n",fi/M_PI*180);
		printf("tt=%f\n",tt/M_PI*180);
		printf("dist=%f\n",r);
		printf("xt=%f  ...  %f\n",xt,xb+r*cos(fi));
		printf("yt=%f  ...  %f\n",yt,yb+r*sin(fi));
		printf("in step %d counter=%d\n",i+1,n);
		getchar();
		}
	}
	printf("%f   %f\n",(double)n/N,(double)n/N*a*b*2*M_PI);
	return 0;
}












