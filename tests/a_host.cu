#include <assert.h>
#include <stdio.h>
#include "a_kernel.hu"
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<time.h>
int main()
{
int a[]={1,2,3,4};
int b[]={1,2,3,4};
int c[4];
int i;
double total_time;
 clock_t start, end;
start = clock();//time count starts 
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
  int *dev_c;
  
  cudaCheckReturn(cudaMalloc((void **) &dev_a, (4) * sizeof(int))); //memory allocation in host
  cudaCheckReturn(cudaMalloc((void **) &dev_b, (4) * sizeof(int)));
  cudaCheckReturn(cudaMalloc((void **) &dev_c, (4) * sizeof(int)));
  
  cudaCheckReturn(cudaMemcpy(dev_a, a, (4) * sizeof(int), cudaMemcpyHostToDevice)); //memory allocation in device
  cudaCheckReturn(cudaMemcpy(dev_b, b, (4) * sizeof(int), cudaMemcpyHostToDevice));
  {
    dim3 k0_dimBlock(4); //4 is no. of blocks 
    dim3 k0_dimGrid(1); //each block has 1 thread
    kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_a, dev_b, dev_c);
    cudaCheckKernel();
  }
  
  cudaCheckReturn(cudaMemcpy(c, dev_c, (4) * sizeof(int), cudaMemcpyDeviceToHost)); //copy result to host
  cudaCheckReturn(cudaFree(dev_a)); //free  memory in device
  cudaCheckReturn(cudaFree(dev_b));
  cudaCheckReturn(cudaFree(dev_c));
}

end = clock();//time count stops 
 total_time = ((double) (end - start));//calulate total time
 printf("\nTime taken is: %f", total_time);

for(i=0;i<4;i++)
printf("%d\n",c[i]);
return 0;
}
