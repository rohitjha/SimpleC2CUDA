#include "a_host.hu"

__global__ void kernel0(int *a, int *b, int *c)
{
	int b0 = blockIdx.x;
	int t0 = threadIdx.x;
	{
{

a[i]=a[i]+b[i];
c[i]=a[i];

}


	}
}
