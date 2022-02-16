#!/bin/bash
set -e
set -x

ANDROID_NDK_ROOT=$1

SCRIPTPATH=`realpath .`

# Set the Android API levels
ANDROID_API=${2:-28}

TARGET_DIR=${3:-$SCRIPTPATH/output}

OPENSSL_DIR=${4:-$SCRIPTPATH/openssl}

# Can be android-arm, android-arm64, android-x86, android-x86_64 etc
#architecture=android-arm64
./launcher.sh $ANDROID_NDK_ROOT android-arm $ANDROID_API $TARGET_DIR $OPENSSL_DIR

#architecture=android-arm
./launcher.sh $ANDROID_NDK_ROOT android-arm64 $ANDROID_API $TARGET_DIR $OPENSSL_DIR

#architecture=android-x86
./launcher.sh $ANDROID_NDK_ROOT android-x86 $ANDROID_API $TARGET_DIR $OPENSSL_DIR

#architecture=android-x86_64
./launcher.sh $ANDROID_NDK_ROOT android-x86_64 $ANDROID_API $TARGET_DIR $OPENSSL_DIR