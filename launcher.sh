#!/bin/bash
set -e
set -x

# Set the Android API levels
ANDROID_API=$1

# Set the target architecture
# Can be android-arm, android-arm64, android-x86, android-x86 etc
architecture=$2

if [[ "$architecture" == android-arm ]]
then arcName=arm-linux-androideabi
elif [[ "$architecture" == android-arm64 ]]
then arcName=aarch64-linux-android
elif [[ "$architecture" == android-x86 ]]
then arcName=i686-linux-android
elif [[ "$architecture" == android-x86_64 ]]
then arcName=x86_64-linux-android
else
arcName="$architecture"
fi

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

# Copy the outputs
OUTPUT_INCLUDE=$SCRIPTPATH/outputStatic/include
OUTPUT_LIB=$SCRIPTPATH/outputStatic/lib/${arcName}/${ANDROID_API}
mkdir -p $OUTPUT_INCLUDE
mkdir -p $OUTPUT_LIB
cp -RL include/openssl $OUTPUT_INCLUDE
cp libcrypto.so $OUTPUT_LIB
cp libcrypto.a $OUTPUT_LIB
cp libssl.so $OUTPUT_LIB
cp libssl.a $OUTPUT_LIB