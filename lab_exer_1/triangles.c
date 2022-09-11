#include <stdio.h>

#define N 5
#define newLine printf("\n")

int main()
{
    // Number of rows to print.
    for (int i = 1; i < (N + 1); i += 2)
    {
        // Number of triangles to print.
        for (int j = 0; j < N; j++)
        {
            // Print the triangle.
            for (int _ = 0; _ < (N - i) / 2; _++)
                printf(" ");

            for (int _ = 0; _ < i; _++)
                printf("*");

            if (j != (N - 1)) // No spaces on the leftmost side.
                for (int _ = 0; _ < (N - i) / 2; _++)
                    printf(" ");

            printf(" "); // One space between triangle bodies.
        }

        newLine;
    }

    return 0;
}
