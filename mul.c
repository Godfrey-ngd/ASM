#include <stdio.h>
 
int main() {
    for (int i = 9; i >= 1; i--) {

        for (int j = 10 - i; j <= 9; j++) {
            printf("%dx%d=%2d", i, j, i * j);
            if (j < 9) {
                printf("  ");  
            }
        }
        printf("\n");
    }
    return 0;
}
