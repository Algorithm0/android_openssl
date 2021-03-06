#!/bin/bash
set -e
set -x

# Set directory
SCRIPTPATH=`realpath .`

export ANDROID_NDK_ROOT=`readlink -m $1`

# Set the target architecture
# Can be android-arm, android-arm64, android-x86, android-x86 etc
architecture=${2:-android-arm}

# Set the Android API levels
ANDROID_API=${3:-28}

TARGET_DIR=${4:-$SCRIPTPATH/output}
if [[ "$TARGET_DIR" != $SCRIPTPATH/output ]]
then TARGET_DIR=`readlink -m $TARGET_DIR`
fi

OPENSSL_DIR=${5:-$SCRIPTPATH/openssl}
if [[ "$OPENSSL_DIR" != $SCRIPTPATH/openssl ]]
then OPENSSL_DIR=`readlink -m $OPENSSL_DIR`
fi

if ! [ -d $OPENSSL_DIR ]; then
git clone https://github.com/openssl/openssl.git -b openssl-3.0.0 ${OPENSSL_DIR}
else
cd ${OPENSSL_DIR}
git clean -fdx
cd ${SCRIPTPATH}
fi

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
OUTPUT_INCLUDE=$TARGET_DIR/include
OUTPUT_LIB=$TARGET_DIR/lib/${ANDROID_API}/${arcName}
mkdir -p $OUTPUT_INCLUDE
mkdir -p $OUTPUT_LIB
cp -RL ${OPENSSL_DIR}/include/openssl $OUTPUT_INCLUDE
cp ${OPENSSL_DIR}/libcrypto.so $OUTPUT_LIB
cp ${OPENSSL_DIR}/libcrypto.a $OUTPUT_LIB
cp ${OPENSSL_DIR}/libssl.so $OUTPUT_LIB
cp ${OPENSSL_DIR}/libssl.a $OUTPUT_LIB

# Clen openssl dir from build files
git clean -fdx