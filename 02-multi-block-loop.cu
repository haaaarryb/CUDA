#include <stdio.h>

__global__ void loop()
{
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    printf("This is iteration number %d\n", i);
}

int main()
{
  loop<<<2, 5>>>();
  cudaDeviceSynchronize();
}
