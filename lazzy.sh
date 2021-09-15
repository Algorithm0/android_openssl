#!/bin/bash
set -e
set -x

# Set the Android API levels
ANDROID_API=28

# Set the target architecture
# Can be android-arm, android-arm64, android-x86, android-x86_64 etc
architecture=android-arm64
./launcher.sh $ANDROID_API $architecture

architecture=android-arm
./launcher.sh $ANDROID_API $architecture

architecture=android-x86
./launcher.sh $ANDROID_API $architecture

architecture=android-x86_64
./launcher.sh $ANDROID_API $architecture

ANDROID_API=26

architecture=android-arm
./launcher.sh $ANDROID_API $architecture

architecture=android-x86
./launcher.sh $ANDROID_API $architecture

architecture=android-x86_64
./launcher.sh $ANDROID_API $architecture

architecture=android-arm64
./launcher.sh $ANDROID_API $architecture