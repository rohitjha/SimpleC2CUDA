#include "a_kernel.hu"
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

int *dev_a;
int *dev_b;
int *dev_c;

cudaMalloc((void **) &dev_a, (10000) * sizeof(int);
cudaMalloc((void **) &dev_b, (10000) * sizeof(int);
cudaMalloc((void **) &dev_c, (10000) * sizeof(int);

cudaMemcpy(dev_a, a, (10000) * sizeof(int), cudaMemcpyHostToDevice);
cudaMemcpy(dev_b, b, (10000) * sizeof(int), cudaMemcpyHostToDevice);

{
	dim3 k0_dimBlock(32);
	dim3 k0_dimGrid(313);
	kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_a, dev_b, dev_c);
}

cudaMemcpy(c, dev_c, (10000) * sizeof(int), cudaMemcpyDeviceToHost);

cudaFree(dev_a);
cudaFree(dev_b);
cudaFree(dev_c);


end = clock();//time count stops 
total_time = (double)(end - start)*1000 / CLOCKS_PER_SEC;//calulate total time in milliseconds
printf("\nTime taken: %f milliseconds\n", total_time);

for(i=0;i<10000;i++)
    printf("%d\n",c[i]);
return 0;
}
