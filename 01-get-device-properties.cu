#include <stdio.h>

int main()
{
  int deviceId;
  cudaGetDevice(&deviceId);                        // `deviceId`  now points to the id of the currently active GPU.
  cudaDeviceProp props;                            // initialise
  cudaGetDeviceProperties(&props, deviceId);       // `props` now has many useful properties about the active GPU device.
  
  
  int computeCapabilityMajor = props.major;
  int computeCapabilityMinor = props.minor;
  int multiProcessorCount = props.multiProcessorCount;
  int warpSize = props.warpSize;

  printf("Device ID: %d\nNumber of SMs: %d\nCompute Capability Major: %d\nCompute Capability Minor: %d\nWarp Size: %d\n", deviceId, multiProcessorCount, computeCapabilityMajor, computeCapabilityMinor, warpSize);
}
