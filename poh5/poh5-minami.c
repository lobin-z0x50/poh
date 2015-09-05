#include <stdio.h>

int main(void){
	int X, Y, x, y;
	int table[20][20] = { { } };
	int after[20][20] = { { } };
	
	scanf("%d %d", &X, &Y);

	for (y = 0; y < Y; y++) {
		for (x = 0; x < X; x++) {
			scanf("%d", &table[y][x]);
		}
	}

	
	for (x = 0; x < X; x++) {
		int ay=Y-1;
		for (y = Y-1; y >= 0; y--) {
			if (table[y][x] == 1) {
				after[ay--][x] = table[y][x];
			}
		}
	}

	for (y = 0; y < Y; y++) {
		for (x = 0; x < X; x++) {
			if (x>0) printf(" ");
			printf("%d", after[y][x]);
		}
		puts("");
	}
	return 0;
}

