#include <stdio.h>

#define YOUR_ANSWER *(a + (r * cols) + c) + *(b + (r * cols) + c)

void print_matrix_sum(int *a, int *b, int rows, int cols)
{
    for (int r = 0; r < rows; r++)
    {
        for (int c = 0; c < cols; c++)
        {
            int sum = YOUR_ANSWER;
            printf("a[%d][%d] + b[%d][%d] = %d\n", r, c, r, c, sum);
        }
    }
}

int main()
{
    int a[3][2] = {10, 20, 30, 40, 50, 60};
    int b[3][2] = {1, 2, 3, 4, 5, 6};

    int *pa = (int *)a;
    int *pb = (int *)b;

    print_matrix_sum(pa, pb, 3, 2);

    return 0;
}
