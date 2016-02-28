#include "call_kernel.hu"
__global__ void kernel0(int *a, int *b)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    #define ppcg_fdiv_q(n,d) (((n)<0) ? -((-(n)+(d)-1)/(d)) : (n)/(d))
    if (32 * b0 + t0 <= 999)
      copy(b, a, (32 * b0 + t0));
}
