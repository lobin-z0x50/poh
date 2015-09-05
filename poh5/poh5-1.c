#include <stdio.h>

int main(void){
	int i = 0;

	do {
    		int c = getchar();
		if (c == 0 || c == '\n') break;
		if (i++ % 2 == 0) printf("%c", c);
	} while (1);

	puts("\n");

	return 0;
}

