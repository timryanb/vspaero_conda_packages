#!/bin/bash

if [[ $(uname) == Darwin ]]; then
  export OS="MacOS"
elif [[ "$target_platform" == linux-* ]]; then
  export OS="Linux"
fi

echo ${PREFIX}
mkdir build buildlibs
cd buildlibs
cmake -DVSP_NO_GRAPHICS=${no_graphics} -DVSP_USE_SYSTEM_LIBXML2=true -DVSP_USE_SYSTEM_FLTK=true \
      -DVSP_USE_SYSTEM_GLM=true -DVSP_USE_SYSTEM_GLEW=true \
      -DVSP_USE_SYSTEM_CMINPACK=true -DVSP_USE_SYSTEM_LIBIGES=false -DVSP_USE_SYSTEM_EIGEN=true \
      -DVSP_USE_SYSTEM_CODEELI=false -DVSP_USE_SYSTEM_CPPTEST=false ../Libraries -DCMAKE_BUILD_TYPE=Release
make -j ${CPU_COUNT} VERBOSE=1
cd ../build
cmake ../src/ -DVSP_NO_GRAPHICS=${no_graphics} -DVSP_LIBRARY_PATH=../buildlibs -DCMAKE_BUILD_TYPE=Release
make -j ${CPU_COUNT} VERBOSE=1
make package
# Install python interface
pushd _CPack_Packages/${OS}/ZIP/OpenVSP-${PKG_VERSION}-${OS}/python
${PYTHON} -m pip install --no-deps --prefix=${PREFIX} -r requirements.txt -vv
cd ..
cp -v vspaero vspscript vsploads ${PREFIX}/bin
if [[ !$(no_graphics) ]]; then
  cp -v vsp ${PREFIX}/bin
fi
echo ${PREFIX}
