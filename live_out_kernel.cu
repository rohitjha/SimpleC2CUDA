#include "live_out_kernel.hu"

__global__ void kernel0(int *A)
{
	int b0 = blockIdx.x;
	int t0 = threadIdx.x;
	{
	int i = 1;
	i = i * i;
	A[i] = 1;
	A[t0] = 0;


	}
}
