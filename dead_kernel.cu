#include "dead_kernel.hu"

__global__ void kernel0(int *a, int *b)
{
	int b0 = blockIdx.x;
	int t0 = threadIdx.x;
	{
    {
		int c;
		int d;
		c = a[t0];
		d = c;
		b[t0] = c;
	}


	}
}
