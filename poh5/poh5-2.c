#include <stdio.h>

int main(void){
	int i, n;
	int sum[7] = {0,0,0,0,0,0,0};

	scanf("%d", &n);
	for (i=0; i<n; i++) {
    		int sales;
		scanf("%d", &sales);
		sum[i%7] += sales;
	}

	for (i=0; i<7; i++) {
		printf("%d\n", sum[i]);
	}	

	return 0;
}

