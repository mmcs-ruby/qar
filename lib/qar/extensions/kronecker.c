#include <stdio.h>
#include <omp.h>

void kronecker(int **a, int **b, int **c, size_t m1, size_t n1, size_t m2, size_t n2)
{
    #pragma omp parallel for
    for(size_t j1 = 0; j1 < m1; ++j1)
    {
        size_t _y = j1 * m1;
        for(size_t i1 = 0; i1 < n1; ++i1)
        {
            size_t _x = i1 * n1;
            for(size_t j2 = 0; j2 < m2; ++j2)
            {
                for(size_t i2 = 0; i2 < n2; ++i2)
                {
                    c[_y + j2][_x + i2] = a[j1][i1] * b[j2][i2];
                }
            }
        }
    }

}

void printm(int **a, size_t m, size_t n)
{
    for (size_t i = 0; i < m; i++)
    {
        for (size_t j = 0; j < n; j++)
        {
            printf("%d\t", a[i][j]);
        }
        printf("\n");
    }
}

int** malloc_matrix(size_t h, size_t w)
{
    int **a = (int **)malloc(h * sizeof(int *));
    for (int i = 0; i < h; i++)
    {
        a[i] = (int *)malloc(w * sizeof(int));
    }
    return a;
}

void rand_matrix(int** a, size_t h, size_t w)
{
    time_t t;
    srand((unsigned) time(&t));
    for(size_t j = 0; j < h; ++j)
    {
        for(size_t i = 0; i < w; ++i)
        {
            a[j][i] = rand() % 20 - 10;
        }
    }
}

int main()
{

    size_t h_a = 100, w_a = 100;
    int **a = malloc_matrix(h_a, w_a);
    rand_matrix(a, h_a, w_a);
    // printm(a, h_a, w_a);


    size_t h_b = 100, w_b = 100;
    int **b = malloc_matrix(h_b, w_b);
    rand_matrix(b, h_b, w_b);
    //printm(b, h_b, w_b);

    size_t h_c = h_a * h_b, w_c = w_a * w_b;
    int **c = malloc_matrix(h_c, w_c);
    kronecker(a, b, c, h_a, w_a, h_b, w_b);
    //printm(c, h_c, h_c);*/
}
