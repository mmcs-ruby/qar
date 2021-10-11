#include <stdio.h>

void kronecker(int **a, int **b, int **c, size_t m1, size_t n1, size_t m2, size_t n2)
{
    size_t x = 0;
    for (size_t i = 0; i < m1; i++)
    {
        size_t y = 0;
        for (size_t j = 0; j < n1; j++)
        {
            for (size_t p = 0; p < m2; p++)
            {
                for (size_t q = 0; q < n2; q++)
                {
                    c[i + p + x][j + q + y] = b[p][q] * a[i][j];
                }
            }
            y += n2 - 1;
        }
        x += m2 - 1;
    }
}

void printm(int **a, size_t m, size_t n)
{
    for (size_t i = 0; i < m; i++)
    {
        for (size_t j = 0; j < n; j++)
        {
            printf("%d ", a[i][j]);
        }
        printf("\n");
    }
}

int main()
{
    int **a = (int **)malloc(2 * sizeof(int *));
    for (int i = 0; i < 2; i++)
    {
        a[i] = (int *)malloc(2 * sizeof(int));
    }

    a[0][0] = 1;
    a[0][1] = 2;
    a[1][0] = 3;
    a[1][1] = 4;

    int **b = (int **)malloc(2 * sizeof(int *));
    for (int i = 0; i < 2; i++)
    {
        b[i] = (int *)malloc(2 * sizeof(int));
    }

    b[0][0] = 0;
    b[0][1] = 5;
    b[1][0] = 6;
    b[1][1] = 7;

    int **c = (int **)malloc(4 * sizeof(int *));
    for (int i = 0; i < 4; i++)
    {
        c[i] = (int *)malloc(4 * sizeof(int));
    }

    kronecker(a, b, c, 2, 2, 2, 2);
    printm(c, 4, 4);
}
