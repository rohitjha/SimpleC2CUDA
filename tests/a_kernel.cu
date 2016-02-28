#include "a_kernel.hu"
__global__ void kernel0(int *a, int *b, int *c)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;
    int private_a[1];

    #define ppcg_fdiv_q(n,d) (((n)<0) ? -((-(n)+(d)-1)/(d)) : (n)/(d))
    {
      private_a[0] = a[t0];
      private_a[0] = (private_a[0] + b[t0]);
      c[t0] = private_a[0];
    }
}
