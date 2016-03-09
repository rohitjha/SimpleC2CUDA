#include "add_kernel.hu"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
    int a[500][500];
    int b[500][500];
    int c[500][500];
    int i, j;
    double total_time;
    clock_t start, end;
  
    srand(time(NULL));
    for(i = 0; i < 500; i++)
        for(j = 0; j < 500; j++)
        {
            a[i][j] = rand();
            b[i][j] = rand();
        }
  
    start = clock();

    
int *dev_a;
int *dev_b;
int *dev_c;

cudaMalloc((void **) &dev_a, (500) *(500) * sizeof(int);
cudaMalloc((void **) &dev_b, (500) *(500) * sizeof(int);
cudaMalloc((void **) &dev_c, (500) *(500) * sizeof(int);

cudaMemcpy(dev_a, a, (500) * sizeof(int), cudaMemcpyHostToDevice);
cudaMemcpy(dev_b, b, (500) * sizeof(int), cudaMemcpyHostToDevice);

{
	dim3 k0_dimBlock(32, 32);
	dim3 k0_dimGrid(16, 16);
	kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_a, dev_b, dev_c);
}

cudaMemcpy(c, dev_c, (500) * sizeof(int), cudaMemcpyDeviceToHost);

cudaFree(dev_a);
cudaFree(dev_b);
cudaFree(dev_c);

    
    end = clock();//time count stops 
    printf("\nThe sum of the two matrices is\n");
    for(i=0;i<500;i++){
        printf("\n");
        for(j=0;j<500;j++)
            printf("%d\t",c[i][j]);
    }
    total_time = (double)(end - start)*1000 / CLOCKS_PER_SEC;//calulate total time in milliseconds
    printf("\nTime taken: %f milliseconds\n", total_time);
    return 0;
}
