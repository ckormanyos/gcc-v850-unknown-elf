#!/usr/bin/env bash
#
#  Copyright Christopher Kormanyos 2023 - 2024.
#  Distributed under The Unlicense.
#
# Example call(s):
#   ./gcc-v850-unknown-elf-100.sh 13.2.0 x86_64-linux-gnu x86_64-linux-gnu
#   ./gcc-v850-unknown-elf-100.sh 13.2.0 x86_64-w64-mingw32 x86_64-w64-mingw32 /c/mingw
#

SCRIPT_PATH=$(readlink -f "$BASH_SOURCE")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

MY_VERSION=$1
BUILD_NAME=$2
HOST_NAME=$3


if [[ "$BUILD_NAME" == "x86_64-w64-mingw32" ]]; then
# echo 'install necessary packages and build tools'
# pacman -S --needed --noconfirm autoconf automake bzip2 cmake git make ninja patch python texinfo wget

# Get standalone msys2 from nuwen (contains standalone gcc-x86_64-w64-mingw32).
# The page describing this is: https://nuwen.net/mingw.html
# The exact download link is: https://nuwen.net/files/mingw/mingw-19.0.exe

# For detailed background information, see also the detailed instructions
# at GitHub from Stephan T. Lavavej's repositiony.
# These can be found here: https://github.com/StephanTLavavej/mingw-distro

OLD_MINGW_PATH=$4
echo 'append standalone gcc-x86_64-w64-mingw32 path'
export X_DISTRO_ROOT="$OLD_MINGW_PATH"
export X_DISTRO_BIN=$X_DISTRO_ROOT/bin
export X_DISTRO_INC=$X_DISTRO_ROOT/include
export X_DISTRO_LIB=$X_DISTRO_ROOT/lib
export PATH=$PATH:$X_DISTRO_BIN
export C_INCLUDE_PATH=$X_DISTRO_INC
export CPLUS_INCLUDE_PATH=$X_DISTRO_INC
echo
fi


echo 'clean gcc_build directory'
rm -rf gcc_build | true


echo 'make and enter gcc_build directory'
mkdir -p $SCRIPT_DIR/gcc_build
echo


echo 'query system gcc'
g++ -v
result_system_gcc=$?
echo "result_system_gcc: " "$result_system_gcc"
echo


cd $SCRIPT_DIR/gcc_build
echo 'get tar-balls'
wget --no-check-certificate https://github.com/facebook/zstd/releases/download/v1.5.5/zstd-1.5.5.tar.gz
wget --no-check-certificate https://ftp.gnu.org/gnu/libiconv/libiconv-1.17.tar.gz
wget --no-check-certificate https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz
wget --no-check-certificate https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz
wget --no-check-certificate https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz
wget --no-check-certificate https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2
wget --no-check-certificate https://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz
wget --no-check-certificate https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.xz
wget --no-check-certificate https://ftp.gnu.org/gnu/gcc/gcc-"$MY_VERSION"/gcc-"$MY_VERSION".tar.xz
wget --no-check-certificate ftp://sourceware.org/pub/newlib/newlib-4.4.0.20231231.tar.gz
echo


cd $SCRIPT_DIR/gcc_build
echo 'build zstd'
tar -xf zstd-1.5.5.tar.gz
mkdir objdir-zstd-1.5.5
cd objdir-zstd-1.5.5
cmake "-DCMAKE_BUILD_TYPE=Release" "-DCMAKE_C_FLAGS=-s -O2" "-DCMAKE_INSTALL_PREFIX=$SCRIPT_DIR/local/zstd-1.5.5" "-DZSTD_BUILD_SHARED=OFF" -G Ninja $SCRIPT_DIR/gcc_build/zstd-1.5.5/build/cmake
ninja
ninja install
echo


cd $SCRIPT_DIR/gcc_build
echo 'build libiconv'
tar -xf libiconv-1.17.tar.gz
mkdir objdir-libiconv-1.17
cd objdir-libiconv-1.17
../libiconv-1.17/configure --prefix=$SCRIPT_DIR/local/libiconv-1.17 --build="$BUILD_NAME" --target="$HOST_NAME" --host="$HOST_NAME" --enable-static --disable-shared
make --jobs=6
make install
echo


cd $SCRIPT_DIR/gcc_build
echo 'build gmp'
tar -xf gmp-6.3.0.tar.xz
mkdir objdir-gmp-6.3.0
cd objdir-gmp-6.3.0
../gmp-6.3.0/configure --prefix=$SCRIPT_DIR/local/gmp-6.3.0 --build="$BUILD_NAME" --target="$HOST_NAME" --host="$HOST_NAME" --enable-static --disable-shared
make --jobs=6
make install
echo


cd $SCRIPT_DIR/gcc_build
echo 'build mpfr'
tar -xf mpfr-4.2.1.tar.xz
mkdir objdir-mpfr-4.2.1
cd objdir-mpfr-4.2.1
../mpfr-4.2.1/configure --prefix=$SCRIPT_DIR/local/mpfr-4.2.1 --build="$BUILD_NAME" --target="$HOST_NAME" --host="$HOST_NAME" --enable-static --disable-shared --with-gmp=$SCRIPT_DIR/local/gmp-6.3.0
make --jobs=6
make install
echo


cd $SCRIPT_DIR/gcc_build
echo 'build mpc'
tar -xf mpc-1.3.1.tar.gz
mkdir objdir-mpc-1.3.1
cd objdir-mpc-1.3.1
../mpc-1.3.1/configure --prefix=$SCRIPT_DIR/local/mpc-1.3.1 --build="$BUILD_NAME" --target="$HOST_NAME" --host="$HOST_NAME" --enable-static --disable-shared --with-gmp=$SCRIPT_DIR/local/gmp-6.3.0 --with-mpfr=$SCRIPT_DIR/local/mpfr-4.2.1
make --jobs=6
make install
echo


cd $SCRIPT_DIR/gcc_build
echo 'build isl'
tar -xjf isl-0.24.tar.bz2
mkdir objdir-isl-0.24
cd objdir-isl-0.24
../isl-0.24/configure --prefix=$SCRIPT_DIR/local/isl-0.24 --build="$BUILD_NAME" --target="$HOST_NAME" --host="$HOST_NAME" --enable-static --disable-shared --with-gmp-prefix=$SCRIPT_DIR/local/gmp-6.3.0
make --jobs=6
make install
echo


cd $SCRIPT_DIR/gcc_build
echo 'build cloog'
tar -xf cloog-0.18.1.tar.gz
mkdir objdir-cloog-0.18.1
cd objdir-cloog-0.18.1
../cloog-0.18.1/configure --prefix=$SCRIPT_DIR/local/cloog-0.18.1 --build="$BUILD_NAME" --target="$HOST_NAME" --host="$HOST_NAME" --enable-static --disable-shared --with-isl=$SCRIPT_DIR/local/isl-0.24 --with-gmp-prefix=$SCRIPT_DIR/local/gmp-6.3.0
make --jobs=6
make install
echo


cd $SCRIPT_DIR/gcc_build
echo 'build binutils'
tar -xf binutils-2.41.tar.xz
mkdir objdir-binutils-2.41-v850-unknown-elf-gcc-"$MY_VERSION"
cd objdir-binutils-2.41-v850-unknown-elf-gcc-"$MY_VERSION"
../binutils-2.41/configure --prefix=$SCRIPT_DIR/local/gcc-"$MY_VERSION"-v850-unknown-elf --target=v850-unknown-elf --enable-languages=c,c++ --build="$BUILD_NAME" --host="$HOST_NAME" --with-pkgversion='Built by ckormanyos/real-time-cpp' --disable-plugins --enable-static --disable-shared --disable-tls --disable-libada --disable-libssp --disable-nls --enable-mingw-wildcard --with-gnu-as --with-dwarf2 --disable-__cxa_atexit --disable-threads --disable-win32-registry --disable-sjlj-exceptions --with-isl=$SCRIPT_DIR/local/isl-0.24 --with-cloog=$SCRIPT_DIR/local/cloog-0.18.1 --with-gmp=$SCRIPT_DIR/local/gmp-6.3.0 --with-mpfr=$SCRIPT_DIR/local/mpfr-4.2.1 --with-mpc=$SCRIPT_DIR/local/mpc-1.3.1 --with-libiconv-prefix=$SCRIPT_DIR/local/libiconv-1.17 --with-zstd=$SCRIPT_DIR/local/zstd-1.5.5/lib --disable-werror
make --jobs=6
make install
echo


ls -la $SCRIPT_DIR/local/gcc-"$MY_VERSION"-v850-unknown-elf/bin
ls -la $SCRIPT_DIR/local/gcc-"$MY_VERSION"-v850-unknown-elf/bin/v850-unknown-elf-ld*
result_binutils=$?


echo "result_binutils: " "$result_binutils"
echo


cd $SCRIPT_DIR/gcc_build
echo 'build gcc'
tar -xf gcc-"$MY_VERSION".tar.xz
tar -xf newlib-4.4.0.20231231.tar.gz
cd newlib-4.4.0.20231231
cp -r newlib libgloss ../gcc-"$MY_VERSION"
cd ..
mkdir objdir-gcc-"$MY_VERSION"-v850-unknown-elf
cd objdir-gcc-"$MY_VERSION"-v850-unknown-elf
../gcc-"$MY_VERSION"/configure --prefix=$SCRIPT_DIR/local/gcc-"$MY_VERSION"-v850-unknown-elf --target=v850-unknown-elf --enable-languages=c,c++ --build="$BUILD_NAME" --host="$HOST_NAME" --with-pkgversion='Built by ckormanyos/real-time-cpp' --disable-gcov --enable-static --disable-shared --with-newlib --disable-tls --disable-libada --disable-libssp --disable-nls --enable-mingw-wildcard --with-gnu-as --with-dwarf2 --disable-__cxa_atexit --disable-threads --disable-win32-registry --disable-sjlj-exceptions --disable-libquadmath --disable-fixed-point --disable-decimal-float --with-isl=$SCRIPT_DIR/local/isl-0.24 --with-cloog=$SCRIPT_DIR/local/cloog-0.18.1 --with-gmp=$SCRIPT_DIR/local/gmp-6.3.0 --with-mpfr=$SCRIPT_DIR/local/mpfr-4.2.1 --with-mpc=$SCRIPT_DIR/local/mpc-1.3.1 --with-libiconv-prefix=$SCRIPT_DIR/local/libiconv-1.17 --with-zstd=$SCRIPT_DIR/local/zstd-1.5.5/lib
make --jobs=6
make install
echo


ls -la $SCRIPT_DIR/local/gcc-"$MY_VERSION"-v850-unknown-elf/bin
ls -la $SCRIPT_DIR/local/gcc-"$MY_VERSION"-v850-unknown-elf/bin/v850-unknown-elf-gcc*
result_gcc=$?


echo "result_gcc: " "$result_gcc"
echo

result_total=$((result_system_gcc+result_binutils+result_gcc))

echo "result_total: " "$result_total"
echo


exit $result_total
