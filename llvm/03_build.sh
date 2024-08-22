#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "${0}")")

export LLVM=${LLVM:?Please set LLVM variable to desired llvm version}

if ! command cmake --version &> /dev/null; then
    echo "Please install cmake version 3.30.1"
    exit 1
fi

DOWNLOADS="${SCRIPT_DIR}/output/downloads"
SYSROOT="${SCRIPT_DIR}/output/sysroot"
SRCS="${SCRIPT_DIR}/output/srcs"
BUILD="${SCRIPT_DIR}/output/build"
STAGING="${SCRIPT_DIR}/output/staging"

mkdir -p "${DOWNLOADS}"
mkdir -p "${SYSROOT}"
mkdir -p "${SRCS}"
mkdir -p "${BUILD}"
mkdir -p "${STAGING}"

VERSION=${LLVM}
MAJOR_VERSION=$(echo "${VERSION}"| cut -d "." -f 1)

ARCHIVE="llvmorg-${VERSION}.tar.gz"
SRCDIR="${SRCS}/llvm-project-llvmorg-${VERSION}"
BUILDDIR="${BUILD}/llvm-${VERSION}"
STAGEDIR="${STAGING}/llvm-${VERSION}"
TOOLCHAINDIR="${STAGING}/toolchain-${VERSION}"

###############################################################################
#
# Download
#
###############################################################################
curl -L --output ${DOWNLOADS}/${ARCHIVE} "https://github.com/llvm/llvm-project/archive/refs/tags/${ARCHIVE}"

rm -rf ${SRCDIR}
tar xvf "${DOWNLOADS}/${ARCHIVE}" -C "${SRCS}"

################################################################################
##
## Build
##
################################################################################
rm -rf "${BUILDDIR}"
mkdir -p "${BUILDDIR}"

cmake \
        -S "${SRCDIR}/llvm" \
        -B "${BUILDDIR}" \
        -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="${STAGEDIR}" \
        -DLLVM_CCACHE_BUILD=ON \
        -DBOOTSTRAP_LLVM_CCACHE_BUILD=ON \
        -C ${SCRIPT_DIR}/llvm-stage1.cmake

#
# Multiple build commands due to: https://github.com/llvm/llvm-project/issues/53561
#
ninja -C "${BUILDDIR}" clang-bootstrap-deps

HOST_TARGET="$(${BUILDDIR}/bin/llvm-config --host-target)"
STAGE1_LIB="${BUILDDIR}/lib"
STAGE2_LIB="${BUILDDIR}/tools/clang/stage2-bins/lib"

LDFLAGS="-L$STAGE2_LIB/$HOST_TARGET -L$STAGE2_LIB -L$STAGE1_LIB/$HOST_TARGET -L$STAGE1_LIB" \
LD_LIBRARY_PATH="$STAGE2_LIB/$HOST_TARGET:$STAGE2_LIB:$STAGE1_LIB/$HOST_TARGET:$STAGE1_LIB" \
ninja -C "${BUILDDIR}" stage2

rm -rf "${STAGEDIR}"
ninja -C "${BUILDDIR}/tools/clang/stage2-bins" install-distribution

rm -rf "${TOOLCHAINDIR}"
mkdir -p "${TOOLCHAINDIR}"

cp -R "${STAGEDIR}" "${TOOLCHAINDIR}/host"
cp -R "${SYSROOT}" "${TOOLCHAINDIR}/sysroot"
cp -R "${TOOLCHAINDIR}/host/"{include,lib,share} "${TOOLCHAINDIR}/sysroot/"

###############################################################################
#
# Package
#
###############################################################################
function get_commit_time() {
  TZ=UTC0 git log -1 \
    --format=tformat:%cd \
    --date=format:%Y-%m-%dT%H:%M:%SZ
}

SOURCE_EPOCH=$(get_commit_time)

tar -c \
    --sort=name \
    --mtime="${SOURCE_EPOCH}" \
    --owner=0 \
    --group=0 \
    --numeric-owner \
    -C "${TOOLCHAINDIR}" . \
    | gzip -n > "${SCRIPT_DIR}/output/llvm-${MAJOR_VERSION}.tar.gz"

sha256sum "${SCRIPT_DIR}/output/llvm-${MAJOR_VERSION}.tar.gz"
