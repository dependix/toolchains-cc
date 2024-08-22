# Dependix Toolchains

Collection of C/C++ toolchains used for hermetic Bazel builds.
Currently supported toolchains are:
- gcc 12.4.0
- gcc 13.3.0
- gcc 14.1.0
- llvm 17.0.6
- llvm 18.1.8

All toolchains are build against:
- kernel headers 5.15
- binutils 2.34
- glibc 2.31

The system running those toolchains and binaries compiled by those toolchains should support those versions.

## Prerequisites

- [crosstool-ng](https://github.com/crosstool-ng/crosstool-ng) a211eaefd11d8e91fdf105d63caa72dd98af3a9f
- [cmake](https://cmake.org/download/) >=3.30.0

## Build GCC
```
cd gcc
export GCC={12,13,14}

mkdir ${PWD}/output/gcc${GCC}
export CT_PREFIX="${PWD}/output/gcc${GCC}"
DEFCONFIG=x86_64-unknown-linux-gnu_gcc${GCC}
```

## Build LLVM
```
cd llvm
./01_linux.sh
./02_glibc.sh
./03_build.sh
```
