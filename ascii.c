#include <stdio.h>

int main() {
    int a = 96;
    for (int i = 2; i > 0; i--) {
        for (int j = 13; j > 0; j--) {
            a++;
            printf("%c", (char)a);
        }
        printf("\n");
    }
    return 0;
}

