#include <assert.h>
#include <stdio.h>
#include "struct_kernel.hu"
#include <stdlib.h>

struct s {
	int c[10][10];
};

int main()
{
	struct s a[10][10], b[10][10];

	for (int i = 0; i < 10; ++i)
		for (int j = 0; j < 10; ++j)
			for (int k = 0; k < 10; ++k)
				for (int l = 0; l < 10; ++l)
					a[i][j].c[k][l] = i + j + k + l;
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

	  struct s *dev_b;
	  
	  cudaCheckReturn(cudaMalloc((void **) &dev_b, (10) * (10) * sizeof(struct s)));
	  
	  {
	    dim3 k0_dimBlock(4, 4, 10);
	    dim3 k0_dimGrid(1, 1);
	    kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_b);
	    cudaCheckKernel();
	  }
	  
	  cudaCheckReturn(cudaMemcpy(b, dev_b, (10) * (10) * sizeof(struct s), cudaMemcpyDeviceToHost));
	  cudaCheckReturn(cudaFree(dev_b));
	}
	for (int i = 0; i < 10; ++i)
		for (int j = 0; j < 10; ++j)
			for (int k = 0; k < 10; ++k)
				for (int l = 0; l < 10; ++l)
					if (b[i][j].c[k][l] != a[i][j].c[k][l])
						return EXIT_FAILURE;

	return EXIT_SUCCESS;
}
