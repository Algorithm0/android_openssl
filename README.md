# Build OpenSSL for Android
These builds are good for building projects for Android that require openssl. For example, tdlib.
You can also create your own assemblies from under Unix system. You can also use WSL on Windows.

## Dependencies
You need to have your android ndk kit in order to complete the build. You can download this set [here](https://developer.android.com/ndk/downloads). You can also use the NDK that is installed on your system from Android Studio.
You need build tools. On Ubuntu you can call:
```
sudo apt-get update
sudo apt-get install build-essential
```
You can also download and put the OpenSSL source files in any place convenient for you, but you don't have to do it - in this case the script will do everything for you (you need `git` installed in the system).

## Build for one architecture
Run the script to do the default build:
```
./launcher.sh path/to/your/ndk
```
In this case, the script will use the default parameters.
You can change the default options by specifying them on the command line in order:
- 1 - path/to/your/ndk (no def)
- 2 - architecture (def: android-arm) Can be android-arm, android-arm64, android-x86, android-x86 etc
- 3 - ANDROID_API (def: 28)
- 4 - dir with ready lib and headers (def: SCRIPTPATH/output)
- 5 - OPENSSL_DIR or where you want to place it (def: SCRIPTPATH/openssl)
You can specify both absolute and relative paths. If the script does not find the specified OPENSSL_DIR, then it will automatically download the [sources](https://github.com/openssl/openssl.git) for the `openssl-3.0.0` tag.
You will get the assembly in the form of this tree:
```
Your output dir
    include
        *include files*
    lib
        Your ANDROID_API
            $architecture (in android documentation view)
                *lib files*
```
## Build for all architectures of the specified api
To do this, you need to run another script:
```
./lazzy.sh path/to/your/ndk
```
The parameters of this script are similar to the parameters of the previous one:
- 1 - path/to/your/ndk (no def)
- 2 - ANDROID_API (def: 28)
- 3 - dir with ready lib and headers (def: SCRIPTPATH/output)
- 4 - OPENSSL_DIR or where you want to place it (def: SCRIPTPATH/openssl)
You will get the assembly in the form of this tree:
```
Your output dir
    include
        *include files*
    lib
        Your ANDROID_API
            armeabi-v7a
                *lib files*
            arm64-v8a
                *lib files*
            x86
                *lib files*
            x86_64
                *lib files*
```
