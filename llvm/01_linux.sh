#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "${0}")")

DOWNLOADS="${SCRIPT_DIR}/output/downloads"
SYSROOT="${SCRIPT_DIR}/output/sysroot"
SRCS="${SCRIPT_DIR}/output/srcs"

mkdir -p "${DOWNLOADS}"
mkdir -p "${SYSROOT}"
mkdir -p "${SRCS}"

VERSION=5.15.165
ARCHIVE="linux-${VERSION}.tar.xz"
SRCDIR="${SRCS}/linux-${VERSION}"

curl -L --output "${DOWNLOADS}/${ARCHIVE}" "https://cdn.kernel.org/pub/linux/kernel/v5.x/${ARCHIVE}"

rm -rf "${SRCDIR}"
tar xvf "${DOWNLOADS}/${ARCHIVE}" -C "${SRCS}"

make -C "${SRCDIR}" headers_install ARCH=x86_64 INSTALL_HDR_PATH="${SYSROOT}"
