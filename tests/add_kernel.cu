#include "add_kernel.hu"
__global__ void kernel0(int *a, int *b, int *c)
{
    int b0 = blockIdx.y, b1 = blockIdx.x;
    int t0 = threadIdx.y, t1 = threadIdx.x;

    #define ppcg_fdiv_q(n,d) (((n)<0) ? -((-(n)+(d)-1)/(d)) : (n)/(d))
    c[t0 * 3 + t1] = (a[t0 * 3 + t1] + b[t0 * 3 + t1]);
}
