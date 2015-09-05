// paiza4-3.c
// https://paiza.jp/poh/enkoi-ending/7e6681ab

#include <stdio.h>
#include <stdlib.h>

int read_int() {
  int result = 0;
  while(1) {
    int c = getc(stdin);
    if(c < '0' || '9' < c) break;
    result *= 10;
    result += c - '0';
  }
  return result;
}

int main(void) {
  int T, N;
  scanf("%d %d\n", &T, &N);
 
  int max = -1;
  int sum = 0;
  int* buff = (int*)malloc(sizeof (int) * T);

  for (int i=0; i<N; ) {
    int val = read_int();

    buff[i%T] = val;
    sum += val;
//    fprintf(stderr, "val=%d sum=%d\n", val, sum);

    i++;
    if (i < T) continue;

    if(sum > max) max = sum;
    sum -= buff[i%T];
  }

  printf("%d\n", max);

  free(buff);
  return 0;
}

