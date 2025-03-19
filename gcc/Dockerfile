FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
RUN { echo 'tzdata tzdata/Areas select Etc'; echo 'tzdata tzdata/Zones/Etc select UTC'; } | debconf-set-selections

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    bison \
    bzip2 \
    flex \
    g++ \
    gawk \
    git \
    gperf \
    help2man \
    libncurses5-dev \
    libstdc++6 \
    libtool \
    libtool-bin \
    make \
    meson \
    ninja-build \
    patch \
    python3-dev \
    rsync \
    texinfo \
    unzip \
    wget \
    xz-utils

RUN wget https://github.com/crosstool-ng/crosstool-ng/archive/a211eaefd11d8e91fdf105d63caa72dd98af3a9f.tar.gz
RUN mkdir crosstool-ng && tar xf a211eaefd11d8e91fdf105d63caa72dd98af3a9f.tar.gz --strip-components=1 -C crosstool-ng

RUN cd crosstool-ng && \
    ./bootstrap && \
    ./configure --prefix=/usr/local && \
    make && \
    make install

RUN rm -rf a211eaefd11d8e91fdf105d63caa72dd98af3a9f.tar.gz
RUN rm -rf crosstool-ng
