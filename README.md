# Dependix Toolchains

Collection of C/C++ toolchains used for hermetic Bazel builds.
Currently supported toolchains are:
- gcc 12.4.0
- gcc 13.3.0
- gcc 14.1.0

All toolchains are build against:
- kernel headers 5.15
- binutils 2.34
- glibc 2.31

The system running those toolchains and binaries compiled by those toolchains should support those versions.

## Prerequisites

- [crosstool-ng](https://github.com/crosstool-ng/crosstool-ng) a211eaefd11d8e91fdf105d63caa72dd98af3a9f

## Build

```
export GCC={12,13,14}

mkdir ${PWD}/output/gcc${GCC}
export CT_PREFIX="${PWD}/output/gcc${GCC}"
DEFCONFIG=x86_64-unknown-linux-gnu_gcc${GCC}
```
