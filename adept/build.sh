#!/bin/bash

./configure --prefix=${PREFIX} --disable-openmp --with-blas=openblas LDFLAGS="-L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib" CXXFLAGS="${CXXFLAGS}"
make -j ${CPU_COUNT}
make check
make install
