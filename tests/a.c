#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<time.h>
int main()
{
int a[]={1,2,3,4};
int b[]={1,2,3,4};
int c[4];
int i;
double total_time;
 clock_t start, end;
start = clock();//time count starts 
#pragma scop
for(i=0;i<4;i++)
{

a[i]=a[i]+b[i];
c[i]=a[i];

}
#pragma endscop

end = clock();//time count stops 
 total_time = ((double) (end - start));//calulate total time
 printf("\nTime taken is: %f", total_time);

for(i=0;i<4;i++)
printf("%d\n",c[i]);
return 0;
}
