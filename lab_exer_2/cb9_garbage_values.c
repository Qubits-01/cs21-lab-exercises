#include <stdio.h>

int main()
{
    int arr[5]; // Declared, but not initialized.

    for (int i = 0; i < 5; i++)
    {
        printf("arr[%d] = %d\n", i, arr[i]);
    }

    return 0;
}