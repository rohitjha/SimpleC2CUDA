#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
    int a[500][500];
    int b[500][500];
    int c[500][500];
    int i, j;
    double total_time;
    clock_t start, end;
  
    srand(time(NULL));
    for(i = 0; i < 500; i++)
        for(j = 0; j < 500; j++)
        {
            a[i][j] = rand();
            b[i][j] = rand();
        }
  
    start = clock();

    #pragma scop
    for(i=0;i<500;i++)
        for(j=0;j<500;j++)
            c[i][j]=a[i][j]+b[i][j];
    #pragma endscop
    
    end = clock();//time count stops 
    printf("\nThe sum of the two matrices is\n");
    for(i=0;i<500;i++){
        printf("\n");
        for(j=0;j<500;j++)
            printf("%d\t",c[i][j]);
    }
    total_time = (double)(end - start)*1000 / CLOCKS_PER_SEC;//calulate total time in milliseconds
    printf("\nTime taken: %f milliseconds\n", total_time);
    return 0;
}
