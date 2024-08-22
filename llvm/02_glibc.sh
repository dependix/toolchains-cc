#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "${0}")")

DOWNLOADS="${SCRIPT_DIR}/output/downloads"
SYSROOT="${SCRIPT_DIR}/output/sysroot"
SRCS="${SCRIPT_DIR}/output/srcs"
BUILD="${SCRIPT_DIR}/output/build"

mkdir -p "${DOWNLOADS}"
mkdir -p "${SYSROOT}"
mkdir -p "${SRCS}"
mkdir -p "${BUILD}"

VERSION=2.31
ARCHIVE="glibc-${VERSION}.tar.gz"
SRCDIR="${SRCS}/glibc-${VERSION}"
BUILDDIR="${BUILD}/glibc-${VERSION}"

curl -L --output "${DOWNLOADS}/${ARCHIVE}" "https://ftp.gnu.org/gnu/glibc/${ARCHIVE}"

rm -rf "${SRCDIR}"
tar xvf "${DOWNLOADS}/${ARCHIVE}" -C "${SRCS}"

rm -rf "${BUILDDIR}"
mkdir -p "${BUILDDIR}"

cd "${BUILDDIR}"

${SRCDIR}/configure \
    --prefix=/ \
    --disable-werror \
    --with-headers=${SYSROOT}/include \
    --without-selinux

make -j $(nproc)

DESTDIR=${SYSROOT} make install
