FROM ubuntu

RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y curl

ARG BINUTILS_VER=2.35
ARG GCC_VER=10.2.0

RUN mkdir -p $HOME/src; \
  cd $HOME/src; \
  curl -s -O https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.gz; \
  tar zxvf binutils-${BINUTILS_VER}.tar.gz; \
  curl -s -O https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.gz; \
  tar zxvf gcc-${GCC_VER}.tar.gz

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential bison \
  flex libgmp3-dev libmpc-dev libmpfr-dev texinfo

ENV PREFIX $HOME/opt/cross
ENV TARGET i686-elf
ENV PATH $PREFIX/bin:$PATH

RUN cd $HOME/src; \
  mkdir build-binutils; \
  cd build-binutils; \
  ../binutils-${BINUTILS_VER}/configure --target=$TARGET --prefix="$PREFIX" \
    --with-sysroot --disable-nls --disable-werror; \
  make; \
  make install

RUN cd $HOME/src; \
  mkdir build-gcc; \
  cd build-gcc; \
  ../gcc-${GCC_VER}/configure --target=$TARGET --prefix="$PREFIX" \
    --disable-nls --enable-languages=c,c++ --without-headers; \
  make all-gcc; \
  make all-target-libgcc; \
  make install-gcc; \
  make install-target-libgcc

WORKDIR /work
