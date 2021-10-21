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
