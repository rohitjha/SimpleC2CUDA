#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<time.h>
int main()
{
int a[]={1,2,3,4,5,6};
int b[]={1,2,3,4,5,6};
int c[4];
int i;

#pragma scop
for(i=0;i<4;i++)
{

c[i]=a[i]+b[i];


}
#pragma endscop


for(i=0;i<4;i++)
printf("%d\n",c[i]);
return 0;
}
