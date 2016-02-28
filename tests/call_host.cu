#include <assert.h>
#include <stdio.h>
#include "call_kernel.hu"
#include <stdlib.h>

void copy_summary(int b[1000], int a[1000], int pos)
{
	b[pos] = 0;
	int c = a[pos];
}

#ifdef pencil_access
__attribute__((pencil_access(copy_summary)))
#endif
void copy(int b[1000], int a[1000], int pos);

int main()
{
	int a[1000], b[1000];

	for (int i = 0; i < 1000; ++i)
		a[i] = i;
	#define ppcg_fdiv_q(n,d) (((n)<0) ? -((-(n)+(d)-1)/(d)) : (n)/(d))
	{
#define cudaCheckReturn(ret) \
  do { \
    cudaError_t cudaCheckReturn_e = (ret); \
    if (cudaCheckReturn_e != cudaSuccess) { \
      fprintf(stderr, "CUDA error: %s\n", cudaGetErrorString(cudaCheckReturn_e)); \
      fflush(stderr); \
    } \
    assert(cudaCheckReturn_e == cudaSuccess); \
  } while(0)
#define cudaCheckKernel() \
  do { \
    cudaCheckReturn(cudaGetLastError()); \
  } while(0)

	  int *dev_a;
	  int *dev_b;
	  
	  cudaCheckReturn(cudaMalloc((void **) &dev_a, (1000) * sizeof(int)));
	  cudaCheckReturn(cudaMalloc((void **) &dev_b, (1000) * sizeof(int)));
	  
	  cudaCheckReturn(cudaMemcpy(dev_a, a, (1000) * sizeof(int), cudaMemcpyHostToDevice));
	  {
	    dim3 k0_dimBlock(32);
	    dim3 k0_dimGrid(32);
	    kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_a, dev_b);
	    cudaCheckKernel();
	  }
	  
	  cudaCheckReturn(cudaMemcpy(b, dev_b, (1000) * sizeof(int), cudaMemcpyDeviceToHost));
	  cudaCheckReturn(cudaFree(dev_a));
	  cudaCheckReturn(cudaFree(dev_b));
	}
	for (int i = 0; i < 1000; ++i)
		if (b[i] != a[i])
			return EXIT_FAILURE;

	return EXIT_SUCCESS;
}
