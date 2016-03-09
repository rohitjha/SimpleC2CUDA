#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
	int a[10000];
    int b[10000];

	for (int i = 0; i < 10000; ++i)
		a[i] = i;

    clock_t start = clock();
    #pragma scop
	for (int i = 0; i < 10000; ++i)
    {
		int c;
		int d;
		c = a[i];
		d = c;
		b[i] = c;
	}
    #pragma endscop
	
    clock_t end = clock();
    double total_time = (double)(end - start)*1000 / CLOCKS_PER_SEC;
    printf ("\nTotal time is: %f milliseconds\n", total_time);

    for (int i = 0; i < 10000; ++i)
		if (b[i] != a[i])
			return EXIT_FAILURE;

	return EXIT_SUCCESS;
}
