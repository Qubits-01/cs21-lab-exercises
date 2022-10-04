#include <stdio.h>

int main()
{
    int n;
    scanf("Input integer n: %d\n", &n);

    printf("%d\n", factorial(n));

    return 0;
}

int factorial(int n)
{
    if (n == 0)
        return 1;

    return n * factorial(n - 1);
}
