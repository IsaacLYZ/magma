#!/bin/bash -e

##
# Pre-requirements:
# - env FUZZER: fuzzer name (from fuzzers/)
# - env TARGET: target name (from targets/)
# + env MAGMA: path to magma root (default: ../../)
# + env ISAN: if set, build the benchmark with ISAN/fatal canaries (default:
#       unset)
# + env HARDEN: if set, build the benchmark with hardened canaries (default:
#       unset)
##

# Android build target information
export BUILD_TARGET=aarch64-linux-android
export API=34

# Set up Android NDK compiler and toolchain
export TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64
export AR=$TOOLCHAIN/bin/llvm-ar
export CC="$TOOLCHAIN/bin/clang --target=$BUILD_TARGET$API"
export AS=$CC
export CXX="$TOOLCHAIN/bin/clang++ --target=$BUILD_TARGET$API"
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip
export NM=$TOOLCHAIN/bin/llvm-nm
export ANDROID=1


