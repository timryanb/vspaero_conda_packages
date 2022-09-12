#!/bin/bash

if [[ $(uname) == Darwin ]]; then
  export OS="MacOS"
elif [[ "$target_platform" == linux-* ]]; then
  export OS="Linux"
fi

mkdir build buildlibs
cd buildlibs
cmake -DVSP_USE_SYSTEM_LIBXML2=true -DVSP_USE_SYSTEM_FLTK=true -DVSP_USE_SYSTEM_GLM=true -DVSP_USE_SYSTEM_GLEW=true -DVSP_USE_SYSTEM_CMINPACK=true -DVSP_USE_SYSTEM_LIBIGES=false -DVSP_USE_SYSTEM_EIGEN=true -DVSP_USE_SYSTEM_CODEELI=false -DVSP_USE_SYSTEM_CPPTEST=false ../Libraries -DCMAKE_BUILD_TYPE=Release
make -j ${CPU_COUNT}
#make DESTDIR=${PREFIX}/libs install
cd ../build
cmake ../src/ -DVSP_LIBRARY_PATH=../buildlibs -DCMAKE_BUILD_TYPE=Release
make -j ${CPU_COUNT}
make package
# Install python interface
pushd _CPack_Packages/${OS}/ZIP/OpenVSP-${PKG_VERSION}-${OS}/python
pip install -r requirements.txt
pushd ..
cp vsp vspaero vspscript vspslicer ${PREFIX}/bin
popd
popd