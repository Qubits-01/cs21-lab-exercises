#include <stdio.h>
#include <stdlib.h>

int main()
{
    int rows = 3;
    int cols = 4;

    int **matrix = malloc(sizeof(int *) * rows);

    for (int r = 0; r < rows; r++)
    {
        matrix[r] = malloc(sizeof(int) * cols);
        printf("&matrix[%d]: %p\n", r, &matrix[r]);

        for (int c = 0; c < cols; c++)
        {
            printf("&matrix[%d][%d]: %p\n", r, c, &matrix[r][c]);
        }
    }

    for (int r = 0; r < rows; r++)
    {
        free(matrix[r]);
    }

    free(matrix);

    return 0;
}
