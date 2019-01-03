#include <stdio.h>
#include <iostream>

void init(int *a, int N)
{
  int i;
  for (i = 0; i < N; ++i)
  {
    a[i] = i;
  }
}

__global__ void doubleElements(int *a, int N)
{

  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = gridDim.x * blockDim.x;

  for (int i = idx; i < N + stride; i += stride)
  {
    a[i] *= 2;
  }
}

bool checkElementsAreDoubled(int *a, int N)
{
  int i;
  for (i = 0; i < N; ++i)
  {
    if (a[i] != i*2) return false;
  }
  return true;
}

int main()
{
  /*
   * Add error handling to this source code to learn what errors
   * exist, and then correct them. Googling error messages may be
   * of service if actions for resolving them are not clear to you.
   */
  

  int N = 10000;
  int *a;

  size_t size = N * sizeof(int);
  
  //cudaError_t err;
  //err = cudaMallocManaged(&a, size);
  cudaMallocManaged(&a, size);
  
  /*
  if (err != cudaSuccess)
  {
    printf("Here is the error: %s", cudaGetErrorString(err));
  }
  printf(err);
  */

  init(a, N);

  size_t threads_per_block = 1024;
  //size_t threads_per_block = 2048;
  size_t number_of_blocks = 32;

  doubleElements<<<number_of_blocks, threads_per_block>>>(a, N);
  
   // Catch errors for both the kernel launch above and any errors that occur during the asynchronous `doubleElements` kernel execution.
  
  cudaError_t syncError = cudaGetLastError();
  cudaError_t asyncError = cudaDeviceSynchronize();
  
  if (syncError != cudaSuccess) printf("Here is an error: %s\n", cudaGetErrorString(syncError));       // invalid configuration argument
  if (asyncError != cudaSuccess) printf("Here is an error: %s\n", cudaGetErrorString(asyncError));     // no error

  bool areDoubled = checkElementsAreDoubled(a, N);
  printf("All elements were doubled? %s\n", areDoubled ? "TRUE" : "FALSE");

  cudaFree(a);
}
