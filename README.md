# CUDA-Programs
The code should have two parts: serial parts(On CPU)and parallel part(On GPU).
Serial part:
Int main: Get vector length from command line. Declare the three vectors(A+B=C). Use malloc to initialize the vectors. And fill the vectors with 1s.
Memory allocation and transfer:
From CPU to GPU, use cudaMalloc to and cudaMemcpy to transfer the vectors to the GPU.
