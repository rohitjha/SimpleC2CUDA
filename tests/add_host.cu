#include <assert.h>
#include <stdio.h>
#include "add_kernel.hu"
 #include<stdio.h>
int main(){
  int a[3][3],b[3][3],c[3][3],i,j;
  printf("Enter the First matrix->");
  for(i=0;i<3;i++)
      for(j=0;j<3;j++)
           scanf("%d",&a[i][j]);
  printf("\nEnter the Second matrix->");
  for(i=0;i<3;i++)
      for(j=0;j<3;j++)
           scanf("%d",&b[i][j]);
  printf("\nThe First matrix is\n");
  for(i=0;i<3;i++){
      printf("\n");
      for(j=0;j<3;j++)
           printf("%d\t",a[i][j]);
  }
  printf("\nThe Second matrix is\n");
  for(i=0;i<3;i++){
      printf("\n");
      for(j=0;j<3;j++)
      printf("%d\t",b[i][j]);
   }
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
     
     cudaCheckReturn(cudaMalloc((void **) &dev_a, (3) * (3) * sizeof(int)));
     cudaCheckReturn(cudaMalloc((void **) &dev_b, (3) * (3) * sizeof(int)));
     cudaCheckReturn(cudaMalloc((void **) &dev_c, (3) * (3) * sizeof(int)));
     
     cudaCheckReturn(cudaMemcpy(dev_a, a, (3) * (3) * sizeof(int), cudaMemcpyHostToDevice));
     cudaCheckReturn(cudaMemcpy(dev_b, b, (3) * (3) * sizeof(int), cudaMemcpyHostToDevice));
     {
       dim3 k0_dimBlock(3, 3);
       dim3 k0_dimGrid(1, 1);
       kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_a, dev_b, dev_c);
       cudaCheckKernel();
     }
     
     cudaCheckReturn(cudaMemcpy(c, dev_c, (3) * (3) * sizeof(int), cudaMemcpyDeviceToHost));
     cudaCheckReturn(cudaFree(dev_a));
     cudaCheckReturn(cudaFree(dev_b));
     cudaCheckReturn(cudaFree(dev_c));
   }
   printf("\nThe Addition of two matrix is\n");
   for(i=0;i<3;i++){
       printf("\n");
       for(j=0;j<3;j++)
            printf("%d\t",c[i][j]);
   }
   return 0;
}
