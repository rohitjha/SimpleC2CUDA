#include "dead_kernel.hu"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
	int a[10000];
    int b[10000];

	for (int i = 0; i < 10000; ++i)
		a[i] = i;

    clock_t start = clock();
    
int *dev_a;
int *dev_b;

cudaMalloc((void **) &dev_a, (10000) * sizeof(int);
cudaMalloc((void **) &dev_b, (10000) * sizeof(int);

cudaMemcpy(dev_a, a, (10000) * sizeof(int), cudaMemcpyHostToDevice);

{
	dim3 k0_dimBlock(32);
	dim3 k0_dimGrid(313);
	kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_a, dev_b);
}

cudaMemcpy(b, dev_b, (10000) * sizeof(int), cudaMemcpyDeviceToHost);

cudaFree(dev_a);
cudaFree(dev_b);

	
    clock_t end = clock();
    double total_time = (double)(end - start)*1000 / CLOCKS_PER_SEC;
    printf ("\nTotal time is: %f milliseconds\n", total_time);

    for (int i = 0; i < 10000; ++i)
		if (b[i] != a[i])
			return EXIT_FAILURE;

	return EXIT_SUCCESS;
}
