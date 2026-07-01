#!/bin/bash

set -e

mkdir -p _build
pushd _build

# configure
cmake \
  ${CMAKE_ARGS} \
  -DCMAKE_CROSSCOMPILING_EMULATOR:STRING="${CMAKE_CROSSCOMPILING_EMULATOR}" \
  -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen:BOOL=true \
  -DCMAKE_OSX_ARCHITECTURES:STRING="${OSX_ARCH}" \
  ${SRC_DIR} \
;

# build
cmake --build . --parallel ${CPU_COUNT} --verbose

# test (flaky on osx-64)
if [[ "${target_platform}" == "linux-64" ]]; then
  ctest --parallel ${CPU_COUNT} --verbose
fi

# install
cmake --build . --parallel ${CPU_COUNT} --verbose --target install
