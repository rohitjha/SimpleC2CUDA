#include "dead_kernel.hu"
#include <stdlib.h>

int main()
{
	int a[1000];
    int b[1000];

	for (int i = 0; i < 1000; ++i)
		a[i] = i;

int *dev_a;
int *dev_b;

cudaMalloc((void **) &dev_a, (1000) * sizeof(int);
cudaMalloc((void **) &dev_b, (1000) * sizeof(int);

cudaMemcpy(dev_a, a, (1000) * sizeof(int), cudaMemcpyHostToDevice);

{
	dim3 k0_dimBlock(32);
	dim3 k0_dimGrid(32);
	kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_a, dev_b);
}

cudaMemcpy(b, dev_b, (1000) * sizeof(int), cudaMemcpyDeviceToHost);

cudaFree(dev_a);
cudaFree(dev_b);

	for (int i = 0; i < 1000; ++i)
		if (b[i] != a[i])
			return EXIT_FAILURE;

	return EXIT_SUCCESS;
}
