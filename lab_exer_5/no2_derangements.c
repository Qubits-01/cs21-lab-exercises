#include <stdio.h>

int calcNoOfDerangements(int);

int main()
{
    int n;

    printf("Input array length n: ");
    scanf("%d", &n);

    printf("%d\n", calcNoOfDerangements(n));

    return 0;
}

int calcNoOfDerangements(int n)
{
    // Base cases.
    if (n == 0 || n == 1)
        return 0;

    if (n == 2)
        return 1;

    // Recursive step.
    return (n - 1) * (calcNoOfDerangements(n - 1) + calcNoOfDerangements(n - 2));
}
