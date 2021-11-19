#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <stdio.h>
#include <math.h>

__global__ void kronecker(int *a, int *b, int *c, size_t m1, size_t n1, size_t m2, size_t n2)
{
    size_t i = blockIdx.x * blockDim.x + threadIdx.x;
    size_t j = blockIdx.y * blockDim.y + threadIdx.y;
    if ((i < m1 * m2) && (j < n1 * n2))
    {
        size_t m = max(m1, m2), n = max(n1, n2);
        c[i * n1 * n2 + j] = a[i / m * n1 + j / n] * b[i % m * n2 + j % n];
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
