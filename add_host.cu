#include "add_kernel.hu"
 #include<stdio.h>
int main(){
  int a[3][3];
  int b[3][3];
  int c[3][3];
  int i,j;
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

int *dev_a;
int *dev_b;
int *dev_c;

cudaMalloc((void **) &dev_a, (3) *(3) * sizeof(int);
cudaMalloc((void **) &dev_b, (3) *(3) * sizeof(int);
cudaMalloc((void **) &dev_c, (3) *(3) * sizeof(int);

cudaMemcpy(dev_a, a, (3) * sizeof(int), cudaMemcpyHostToDevice);
cudaMemcpy(dev_b, b, (3) * sizeof(int), cudaMemcpyHostToDevice);

{
	dim3 k0_dimBlock(3, 3);
	dim3 k0_dimGrid(1, 1);
	kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_a, dev_b, dev_c);
}

cudaMemcpy(c, dev_c, (3) * sizeof(int), cudaMemcpyDeviceToHost);

cudaFree(dev_a);
cudaFree(dev_b);
cudaFree(dev_c);

   printf("\nThe Addition of two matrix is\n");
   for(i=0;i<3;i++){
       printf("\n");
       for(j=0;j<3;j++)
            printf("%d\t",c[i][j]);
   }
   return 0;
}
