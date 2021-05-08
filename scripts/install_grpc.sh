#!/usr/bin/env bash

set -e
set -x

if [ -z ${GRPC_DIR+x} ]; then
    GRPC_DIR=$(pwd)/third_party/grpc;
fi

PREFIX=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}

NPROCS=$(getconf _NPROCESSORS_ONLN)

pushd ${GRPC_DIR}

# Ask PyTorch if it has been compiled with -D_GLIBCXX_USE_CXX11_ABI=0 (old ABI).
# See https://github.com/pytorch/pytorch/issues/17492.
GLIBCXX_USE_CXX11_ABI=$(python -c "import torch; print(int(torch._C._GLIBCXX_USE_CXX11_ABI))")
export EXTRA_CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=$GLIBCXX_USE_CXX11_ABI"

# Install protobuf. We don't use the conda package as PyTorch insists
# on using a different ABI.
pushd ${GRPC_DIR}/third_party/protobuf
./autogen.sh && ./configure --prefix=${PREFIX} \
    CFLAGS="-fPIC" CXXFLAGS="-fPIC ${EXTRA_CXXFLAGS}"
make -j ${NPROCS} && make install
ldconfig || true
popd

# Make make find libprotobuf
export CPATH=${PREFIX}/include:${CPATH}
export LIBRARY_PATH=${PREFIX}/lib:${LIBRARY_PATH}
export LD_LIBRARY_PATH=${PREFIX}/lib:${LD_LIBRARY_PATH}

make -j ${NPROCS} prefix=${PREFIX} EXTRA_CXXFLAGS=${EXTRA_CXXFLAGS} \
    HAS_SYSTEM_PROTOBUF=true HAS_SYSTEM_CARES=false
make prefix=${PREFIX} \
    HAS_SYSTEM_PROTOBUF=true HAS_SYSTEM_CARES=false install

popd
