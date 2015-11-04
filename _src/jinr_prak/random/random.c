#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

double drand()
{  return (double)rand();  }
double rand1()
{  return drand()/RAND_MAX;  }
double rand2()
{  return (drand()*RAND_MAX+drand())/RAND_MAX/RAND_MAX;  }
double rand3()
{  return (drand()*RAND_MAX*RAND_MAX+drand()*RAND_MAX+drand())/RAND_MAX/RAND_MAX/RAND_MAX;  }

#define rand rand3
double gauss_rand()
{
  int i;
  double s=0;
  for(i=0; i<12; i++)
    s+=rand();
  return (s-6);
}

void rand_array(double * arr, int n, double (*randf)())
{
  int i;
  for(i=0; i<n; i++)
  {
    arr[i]=randf();
    //    printf("%f ",arr[i]);
  }
}

double average(double * arr, int n)
{
  int i;
  double s=0;
  for(i=0; i<n; i++)
    s+=arr[i];
  return s/n;
}
double dispers(const double * arr, int n, double average)
{
  int i;
  double s=0;
//  printf("\n===dispers===\n");
  for(i=0; i<n; i++)
  {
    s+=(arr[i]*arr[i]);
	//printf("arr[%d]=%f; -..-^2=%f; s=%f\n",i,arr[i],arr[i]*arr[i],s);
  }
//  printf("s=%f; aver=%f; s-aver^2*n=%f, -..-/(n-1)=dispers=%f\n\n",
//	s,average,(s-average*average*n),(s-average*average*n)/(n-1));
  return (s-average*average*n)/(n-1);
}
double k_moment(int K, const double * arr, int n, double average)
{
	int i;
	double s=0;
	for(i=0; i<n; i++)
	{
		double x=arr[i]-average;
		double m=1;
		int k=K;
		while(k)
		{
			if(k&1)
				m*=x;
			k>>=1;
			x*=x;
		}
		s+=m;
	}
	return s/n;
}

double bidlo_dispers(const double * arr, int n, double average)
{
  int i;
  double s=0;
//  printf("\n===bidlo_dispers/*aver=%f*/===\n",average);
  for(i=0; i<n; i++)
  {
    s+=((arr[i]-average)*(arr[i]-average));
	//printf("(arr[%d]-aver)=%f; -..-^2=%f; s=%f\n",i,(arr[i]-average),
	//(arr[i]-average)*(arr[i]-average),s);
  }
//  printf("s=%f, s/(n-1)=dispers=%f\n\n",s,s/(n-1));
  return s/(n-1);
}
void printhist(double * arr, int n, double a, double d, double b)
{
  double bin;
  int ss=0;
  for(bin=a; bin+d<b; bin+=d)
  {
    int i;
    int s=0;
    for(i=0; i<n; i++)
      if(arr[i]>=bin && arr[i]<bin+d)
	s++, ss++;
    printf("[%f .. %f) : %d\n",bin,bin+d,s);
  }
  printf("total: %d\n",ss);
}

void analise(double arr[], size_t size, char * name)
{
	printf("%s\n",name);
	double aver=average(arr,size);
	double cc=sqrt(dispers(arr,size,aver));
	printf("aver=%f; cigma=%f\n",aver,cc);
	printf("skewness=%f\n",k_moment(3,arr,size,aver)/cc/cc/cc);
	printf("kurtosis=%f\n",k_moment(4,arr,size,aver)/cc/cc/cc/cc-3);
}

#define DEFAULT_SIZE 1000000
size_t size;
int main(int argc, char * argv[])
{
  if(argc==1)
  {
    time_t t;
    size=DEFAULT_SIZE;
    srand(time(&t));
  }
  else
  { 
    time_t t;
    if(strcmp(argv[1],"n"))
      srand(time(&t));
    else
      srand(atoi(argv[1]));
      
    if(argc==2)
      size=DEFAULT_SIZE;
    else
      size=(int)strtol(argv[2],0,10);//atoi()
  }

  double * arr=(double*)malloc(size*sizeof(double));

  rand_array(arr,size,rand);
  analise(arr,size,"=== random [0..1] ===");

  rand_array(arr,size,gauss_rand);
  analise(arr,size,"=== gauss ===");

  int datasize=0;
  FILE * f=fopen("Landau.dat","r");
  while(!feof(f))
  {
    if(++datasize >size)
    {
      size*=1.5;
      arr=realloc(arr,size);
      if(!arr)
      {
	printf("out of memory");
	exit(1);
      }
    }
    fscanf(f,"%lf\n",arr+datasize-1);
  }
  fclose(f);
  analise(arr,datasize,"=== Landau.dat ===");
  printhist(arr,datasize,-10,1,50);

  free(arr);
}
