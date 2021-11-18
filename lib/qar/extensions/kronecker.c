#include <stdio.h>
#include <omp.h>
#include <math.h>
#include <complex.h>

void kronecker(int *a, int *b, int *c, size_t m1, size_t n1, size_t m2, size_t n2)
{
    #pragma omp parallel for

    for (size_t j1 = 0; j1 < m1; ++j1)
    {
        size_t j1n1m2n2 =  j1 * n1 * m2 * n2;
        for (size_t i1 = 0; i1 < n1; ++i1)
        {
            size_t i1n2 = i1 * n2;
            size_t _a_row = j1 * n1;
            for (size_t j2 = 0; j2 < m2; ++j2)
            {
                size_t j2n1n2 = j2 * n1 * n2;
                size_t _b_row = j2 * n2;
                for (size_t i2 = 0; i2 < n2; ++i2)
                {
                    c[j1n1m2n2 + j2n1n2 + i1n2 + i2] = a[_a_row + i1] * b[_b_row + i2];
                    // c[j1 * n1 * m2 * n2 + j2 * n1 * n2 + i1 * n2 + i2] = a[n1 * j1 + i1] * b[j2 * n2 + i2];
                }
            }
        }
    }
}

void rand_matrix(int *a, size_t h, size_t w)
{
    time_t t;
    srand((unsigned)time(&t));
    for (size_t i = 0; i < h; ++i)
    {
        for (size_t j = 0; j < w; ++j)
        {
            a[i * w + j] = rand() % 20 - 10;
        }
    }
}

void printm(int *a, size_t m, size_t n)
{
    for (size_t i = 0; i < m; i++)
    {
        for (size_t j = 0; j < n; j++)
        {
            printf("%d\t", a[i * n + j]);
        }
        printf("\n");
    }
    printf("\n");
}

int main()
{

    size_t h_a = 100, w_a = 100;
    int *a = (int *)malloc(h_a * w_a * sizeof(int));
    rand_matrix(a, h_a, w_a);
    // printm(a, h_a, w_a);

    size_t h_b = 100, w_b = 100;
    int *b = (int *)malloc(h_b * w_b * sizeof(int));
    rand_matrix(b, h_b, w_b);
    // printm(b, h_b, w_b);

    size_t h_c = h_a * h_b, w_c = w_a * w_b;
    int *c = (int *)malloc(h_c * w_c * sizeof(int));
    kronecker(a, b, c, h_a, w_a, h_b, w_b);
    // printm(c, h_c, w_c);
}
