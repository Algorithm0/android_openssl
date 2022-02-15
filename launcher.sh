#!/bin/bash
set -e
set -x

# Set the Android API levels
ANDROID_API=$1

# Set the target architecture
# Can be android-arm, android-arm64, android-x86, android-x86 etc
architecture=$2

# Set directory
SCRIPTPATH=`realpath .`
export ANDROID_NDK_ROOT=$SCRIPTPATH/android-ndk-r23
OPENSSL_DIR=$SCRIPTPATH/openssl

if ! [ -d $OPENSSL_DIR ]; then
git clone https://github.com/openssl/openssl.git -b openssl-3.0.0
else
cd ${OPENSSL_DIR}
git clean -fdx
cd ${SCRIPTPATH}
fi

# Get opessl from git
# git clone https://github.com/openssl/openssl.git -b openssl-3.0.0

# Find the toolchain for your build machine
toolchains_path=$(python3 toolchains_path.py --ndk ${ANDROID_NDK_ROOT})

# Configure the OpenSSL environment, refer to NOTES.ANDROID in OPENSSL_DIR
# Set compiler clang, instead of gcc by default
CC=clang

# Add toolchains bin directory to PATH
PATH=$toolchains_path/bin:$PATH

# Create the make file
cd ${OPENSSL_DIR}
./Configure ${architecture} -D__ANDROID_API__=$ANDROID_API

# Build
make -j8

if ("${ANDROID_ABI}" STREQUAL "x86")
  set(arcName i686-linux-android)
elseif("${ANDROID_ABI}" STREQUAL "armeabi-v7a")
  set(arcName arm-linux-androideabi)
elseif("${ANDROID_ABI}" STREQUAL "arm64-v8a")
  set(arcName aarch64-linux-android)
elseif("${ANDROID_ABI}" STREQUAL "x86_64")
  set(arcName x86_64-linux-android)
endif()

if [[ "$architecture" == android-arm ]]
then arcName=armeabi-v7a
elif [[ "$architecture" == android-arm64 ]]
then arcName=arm64-v8a
elif [[ "$architecture" == android-x86 ]]
then arcName=x86
elif [[ "$architecture" == android-x86_64 ]]
then arcName=x86_64
else
arcName="$architecture"
fi

# Copy the outputs
OUTPUT_INCLUDE=$SCRIPTPATH/outputStatic/include
OUTPUT_LIB=$SCRIPTPATH/outputStatic/lib/${ANDROID_API}/${arcName}
mkdir -p $OUTPUT_INCLUDE
mkdir -p $OUTPUT_LIB
cp -RL include/openssl $OUTPUT_INCLUDE
cp libcrypto.so $OUTPUT_LIB
cp libcrypto.a $OUTPUT_LIB
cp libssl.so $OUTPUT_LIB
cp libssl.a $OUTPUT_LIB
