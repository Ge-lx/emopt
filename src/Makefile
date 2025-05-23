UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
# Linux
	CC = g++
	SHARED_FLAG = -shared
else
	ifeq ($(UNAME), Darwin)
# OS X
		CC = g++
		SHARED_FLAG = -dynamiclib
	else
		CC = g++
	endif
endif

CXXFLAGS = -Wall -fopenmp -O3 -march=native -DNDEBUG -std=c++11

INCLUDES = -I${EIGEN_DIR} -I${BOOST_DIR} -I/usr/include/eigen3
INCLUDE_CUDA = -I/usr/local/cuda/include/
LDFLAGS = -lpthread

all: Grid.o Grid_ctypes.o FDTD.o Grid.cpp Grid.hpp Grid_ctypes.cpp Grid_ctypes.hpp fdtd.cpp fdtd.hpp
	${CC} ${SHARED_FLAG} -fopenmp -fPIC -o Grid.so Grid.o Grid_ctypes.o ${LDFLAGS}
	${CC} ${SHARED_FLAG} -fopenmp -fPIC -o FDTD.so FDTD.o ${LDFLAGS}
	cp Grid.so ../emopt
	cp FDTD.so ../emopt

Grid.o: Grid.cpp Grid.hpp
	${CC} -c -fPIC Grid.cpp ${CXXFLAGS} -o Grid.o ${INCLUDES}

Grid_ctypes.o: Grid.cpp Grid.hpp Grid_ctypes.cpp Grid_ctypes.hpp
	${CC} -c -fPIC Grid_ctypes.cpp ${CXXFLAGS} -o Grid_ctypes.o ${INCLUDES}

FDTD.o: fdtd.cpp fdtd.hpp
	${CC} -c -fPIC fdtd.cpp ${CXXFLAGS} -o FDTD.o ${INCLUDES} ${INCLUDE_CUDA}

clean:
	rm -f ./*.o
	rm -f ./*.so
	rm -f ../emopt/*.so
	rm -f ../emopt/*.pyc

