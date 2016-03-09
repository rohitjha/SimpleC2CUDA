#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<time.h>
int main()
{
int a[10000];
int b[10000];
int c[10000];
int i;
double total_time;
clock_t start, end;
srand(time(NULL));
for(i = 0; i < 10000; i++)
{
    a[i] = rand();
    b[i] = rand();
}

start = clock();//time count starts 
#pragma scop
for(i=0;i<10000;i++)
{

c[i]=a[i]+b[i];

}
#pragma endscop

end = clock();//time count stops 
total_time = (double)(end - start)*1000 / CLOCKS_PER_SEC;//calulate total time in milliseconds
printf("\nTime taken: %f milliseconds\n", total_time);

for(i=0;i<10000;i++)
    printf("%d\n",c[i]);
return 0;
}
