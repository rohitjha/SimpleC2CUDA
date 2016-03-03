#include "a_kernel.hu"

__global__ void kernel0(int *a, int *b, int *c)
{
	int b0 = blockIdx.x;
	int t0 = threadIdx.x;
	{
{

c[t0]=a[t0]+b[t0];

}


	}
}
