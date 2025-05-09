#!/bin/bash

echo "Compiling FDTD (CUDA)..."
nvcc -Xcompiler -fPIC -O3 -std=c++14 -arch sm_52 \
	-gencode=arch=compute_52,code=sm_52 \
	-gencode=arch=compute_60,code=sm_60 \
	-gencode=arch=compute_61,code=sm_61 \
	-gencode=arch=compute_70,code=sm_70 \
	-gencode=arch=compute_75,code=sm_75 \
	-gencode=arch=compute_80,code=sm_80 \
	-gencode=arch=compute_86,code=sm_86 \
	-gencode=arch=compute_86,code=compute_86 -shared fdtd.cu -o FDTD.so

echo "Compiling Grid (CUDA)..."
nvcc -Xcompiler -fPIC -c -arch sm_52 \
	-gencode=arch=compute_52,code=sm_52 \
	-gencode=arch=compute_60,code=sm_60 \
	-gencode=arch=compute_61,code=sm_61 \
	-gencode=arch=compute_70,code=sm_70 \
	-gencode=arch=compute_75,code=sm_75 \
	-gencode=arch=compute_80,code=sm_80 \
	-gencode=arch=compute_86,code=sm_86 \
	-gencode=arch=compute_86,code=compute_86 Grid_CUDA.cu -o Grid_CUDA.o

echo "Compiling Grid (CPP)..."
g++ -c -fPIC Grid_CPP.cpp -fopenmp -O3 -march=native -DNDEBUG -std=c++14 -o Grid.o -I/opt/emopt/include/ -I/usr/local/cuda/include/ -I/usr/include/eigen3

echo "Linking Grid..."
g++ -shared -fopenmp -fPIC -o Grid.so Grid.o Grid_CUDA.o -lpthread -lrt -ldl -L/usr/local/cuda/lib64 -lcudart_static -lculibos

echo "Copying objects..."

# Kinda fragile, but not the worst of it
EMOPT_PKG_PATH=$(pip3 show emopt | sed 's/\n/\n/g' | sed '8q;d' | sed 's/ /\n/g' | sed '2q;d')
EMOPTPATH="$EMOPT_PKG_PATH/emopt/"

echo "Copying shared objects to $EMOPTPATH"
mv *.so $EMOPTPATH
