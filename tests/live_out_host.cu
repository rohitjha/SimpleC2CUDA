#include <assert.h>
#include <stdio.h>
#include "live_out_kernel.hu"
#include <stdlib.h>

/* Check that a write access is not removed from the live-out
 * accesses only because a strict subset of the (potentially)
 * accessed elements are killed by a later write.
 */
int main()
{
	int A[10];

	A[1] = 0;
	/* ppcg generated CPU code */
	
	#define ppcg_fdiv_q(n,d) (((n)<0) ? -((-(n)+(d)-1)/(d)) : (n)/(d))
	int i;
	{
	  i = ((1) * (1));
	  A[i] = 1;
	  A[0] = 0;
	}
	if (A[1] != 1)
		return EXIT_FAILURE;

	return EXIT_SUCCESS;
}
