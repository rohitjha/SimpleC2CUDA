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
cudaFree(dev_a);
cudaFree(dev_b);

	for (int i = 0; i < 1000; ++i)
		if (b[i] != a[i])
			return EXIT_FAILURE;

	return EXIT_SUCCESS;
}
