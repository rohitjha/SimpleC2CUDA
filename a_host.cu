#include "a_kernel.hu"
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

int *dev_a;
int *dev_b;
int *dev_c;

cudaMalloc((void **) &dev_a, (4) * sizeof(int);
cudaMalloc((void **) &dev_b, (4) * sizeof(int);
cudaMalloc((void **) &dev_c, (4) * sizeof(int);

cudaMemcpy(dev_a, a, (4) * sizeof(int), cudaMemcpyHostToDevice);
cudaMemcpy(dev_b, b, (4) * sizeof(int), cudaMemcpyHostToDevice);

{
	dim3 k0_dimBlock(4);
	dim3 k0_dimGrid(1);
	kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_a, dev_b, dev_c);
}

cudaMemcpy(c, dev_c, (4) * sizeof(int), cudaMemcpyDeviceToHost);

cudaFree(dev_a);
cudaFree(dev_b);
cudaFree(dev_c);


end = clock();//time count stops 
 total_time = ((double) (end - start));//calulate total time
 printf("\nTime taken is: %f", total_time);

for(i=0;i<4;i++)
printf("%d\n",c[i]);
return 0;
}
