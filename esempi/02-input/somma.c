#include <stdio.h>

int main(void) {
    int a, b;

    printf("Primo numero: ");
    scanf("%d", &a);

    printf("Secondo numero: ");
    scanf("%d", &b);

    printf("%d + %d = %d\n", a, b, a + b);
    return 0;
}
