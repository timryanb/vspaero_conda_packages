#!/bin/bash

./configure --prefix=${PREFIX} CXXFLAGS="-O3 -march=native" --disable-openmp --with-blas=openblas LDFLAGS="-L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
make -j ${CPU_COUNT}
make check
make install
