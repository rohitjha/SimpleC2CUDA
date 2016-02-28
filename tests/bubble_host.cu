#include <assert.h>
#include <stdio.h>
#include "bubble_kernel.hu"
 #include<stdio.h>
int main(){

  int s,temp,i,j,a[20];

  printf("Enter total numbers of elements: ");
  scanf("%d",&s);

  printf("Enter %d elements: ",s);
  for(i=0;i<s;i++)
      scanf("%d",&a[i]);

  //Bubble sorting algorithm
  /* ppcg generated CPU code */
  
  #define ppcg_fdiv_q(n,d) (((n)<0) ? -((-(n)+(d)-1)/(d)) : (n)/(d))
  for (int c0 = -s + 2; c0 <= 0; c0 += 1)
    for (int c1 = 0; c1 <= -c0; c1 += 1)
      if (a[c1] > a[c1 + 1]) {
        temp = a[c1];
        a[c1] = a[c1 + 1];
        a[c1 + 1] = temp;
      }
  printf("After sorting: ");
  for(i=0;i<s;i++)
      printf(" %d",a[i]);

  return 0;
}
