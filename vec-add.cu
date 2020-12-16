// Adapted from vec-add-start.cu
#include <stdio.h>

__global__ void add(int *a, int *b, int *c,int length) { 
  // calculate the unique thread index
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  // perform tid-th elements addition 
  if (tid < length) {
    c[tid] = a[tid] + b[tid];
  }
}

__host__ void usage() {
	fprintf(stderr, "Usage: vec-add size\n");
	exit(1);
}


int main(int argc, char** argv) {
  int *d_a, *d_b, *d_c; // device copies of a, b, c 
  int length; 
  int threadsPerBlock,blocksPerGrid;

  ///Setup input vector size
  if (argc != 2) 
    usage();
  if (sscanf(argv[1], "%d", &length) != 1) 
    usage();
               
  //allocate memory for host vectors in CPU
  int* a = (int*)malloc(sizeof(int)*length);
  int* b = (int*)malloc(sizeof(int)*length);
  int* c = (int*)malloc(sizeof(int)*length);

  //initialize vector contents
  for (int i=0;i<length;i++){
    a[i]=1;
    b[i]=1;
  }

  //Max threads per block for lo0 from DQ
  if (length<1024){
    threadsPerBlock = length;
    blocksPerGrid   = 1;
  } else {
    threadsPerBlock = 1024;
    blocksPerGrid   = ceil(double(length)/double(threadsPerBlock));
  }


  // Allocate space for device copies of a, b, c
  cudaMalloc((void **)&d_a, sizeof(int)*length); 
  cudaMalloc((void **)&d_b, sizeof(int)*length); 
  cudaMalloc((void **)&d_c, sizeof(int)*length);

  // Copy inputs to device
  cudaMemcpy(d_a, a, sizeof(int)*length, cudaMemcpyHostToDevice); 
  cudaMemcpy(d_b, b, sizeof(int)*length, cudaMemcpyHostToDevice);

  // Launch add() kernel on GPU
  add<<<blocksPerGrid,threadsPerBlock>>>(d_a, d_b, d_c,length);

  // Copy result back to host
  cudaMemcpy(c, d_c, sizeof(int)*length, cudaMemcpyDeviceToHost);
  fprintf(stdout, "There are %d 2s in vector c\n", length); 

  // Cleanup
  cudaFree(d_a); 
  cudaFree(d_b); 
  cudaFree(d_c);
  
  free(a);
  free(b);
  free(c);

  return(0);
}
