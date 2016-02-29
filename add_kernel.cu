#include "add_kernel.hu"

__global__ void kernel0(int *a, int *b, int *c)
{
	int b0 = blockIdx.y;
	int b1 = blockIdx.x;
	int t0 = threadIdx.y;
	int t1 = threadIdx.x;
	{
            c[t0*3+t1]=a[t0*3+t1]+b[t0*3+t1];


	}
}
