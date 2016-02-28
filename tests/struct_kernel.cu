#include "struct_kernel.hu"
struct s {
    int c[10][10];
};
__global__ void kernel0(struct s *b)
{
    int b0 = blockIdx.y, b1 = blockIdx.x;
    int t0 = threadIdx.z, t1 = threadIdx.y, t2 = threadIdx.x;

    #define ppcg_fdiv_q(n,d) (((n)<0) ? -((-(n)+(d)-1)/(d)) : (n)/(d))
    for (int c5 = t1; c5 <= 9; c5 += 4)
      for (int c6 = t2; c6 <= 9; c6 += 4)
        for (int c7 = 0; c7 <= 9; c7 += 1)
          b[t0 * 10 + c5].c[c6][c7] = ((((t0) + (c5)) + (c6)) + (c7));
}
