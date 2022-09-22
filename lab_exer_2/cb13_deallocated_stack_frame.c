#include <stdio.h>

int *get_multiples(int n, int k)
{
    int ret[k];
    int *p = ret;

    for (int i = 0; i < k; i++)
    {
        ret[i] = n * i;
        printf("ret[%d]: %d\n", i, ret[i]);
    }

    return p;
}

void some_function()
{
    int arr[100] = {};

    for (int i = 0; i < 100; i++)
    {
        arr[i] = 21;
    }
}

int main()
{
    int k = 10;
    int *p = get_multiples(21, k);

    for (int i = 0; i < k; i++)
    {
        printf("p[%d]: %d\n", i, p[i]);
    }

    some_function();

    for (int i = 0; i < k; i++)
    {
        printf("p[%d]: %d\n", i, p[i]);
    }

    return 0;
}
