#include <stdio.h>

int main()
{
    int arr1[3] = {10, 20, 30}; // Explicit size
    int arr2[] = {40, 50, 60};  // Implicit size
    int arr3[3] = {};           // Initializes all elements to 0.

    for (int i = 0; i < 3; i++)
    {
        printf("arr1[%d] = %d\n", i, arr1[i]);
        printf("arr2[%d] = %d\n", i, arr2[i]);
        printf("arr3[%d] = %d\n", i, arr3[i]);
    }

    return 0;
}