#!/bin/bash -e

##
# Pre-requirements:
# - env FUZZER: fuzzer name (from fuzzers/)
# - env TARGET: target name (from targets/)
# + env ANDROID: if set, prepare compilation environment for Android (default:0)
# + env MAGMA_R: path to magma root (default: ../../)
# + env ISAN: if set, build the benchmark with ISAN/fatal canaries (default:
#       unset)
# + env HARDEN: if set, build the benchmark with hardened canaries (default:
#       unset)
##

if [ -z $FUZZER ] || [ -z $TARGET ]; then
    echo '$FUZZER and $TARGET must be specified as environment variables.'
    exit 1
fi
MAGMA_R=${MAGMA_R:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/../../" >/dev/null 2>&1 \
    && pwd)"}
source "$MAGMA_R/tools/captain/common_env.sh"

## IMPORTANT 
# $MAGMA_R is the root of magma repo
# $MAMGA is $MAGMA_R/magma
##

if [ -n "$ANDROID" ]; then
	echo "==============Step 0 set up for Android environment==============="
    source "$MAGMA_R/tools/captain/android_env.sh"
fi

mkdir -p $SHARED $OUT
chmod 744 $SHARED $OUT

echo "==============Step 1 prebuild magma==============="
# sh $MAGMA/preinstall.sh
sh $MAGMA/prebuild.sh

echo "==============Step 2 build $FUZZER==============="
FUZZER=$MAGMA_R/fuzzers/$FUZZER
# sh $FUZZER/preinstall.sh
if [ ! -d $FUZZER/repo ]; then
	sh $FUZZER/fetch.sh
fi

echo "==============Step 3 prepare $TARGET==============="
TARGET=$MAGMA_R/targets/$TARGET
# sh $TARGET/preinstall.sh
if [ ! -d $TARGET/repo ]; then
	sh $TARGET/fetch.sh
	sh $MAGMA/apply_patches.sh
fi

echo "==============Step 4 build $TARGET==============="

if [ -n "$ISAN" ]; then
	ISAN_FLAG="-DMAGMA_FATAL_CANARIES"
fi

if [ -n "$HARDEN" ]; then
	HARDEN_FLAG="-DMAGMA_HARDEN_CANARIES"
fi

# TODO: Add CANARIES flag and FIXES flag
# Refer to build.sh

# BUILD_FLAGS="-include ${MAGMA}/src/canary.h ${CANARIES_FLAG} ${FIXES_FLAG} ${ISAN_FLAG} ${HARDEN_FLAG} -g -O0"

# export CFLAGS=$BUILD_FLAGS
# export CXXFLAGS=$BUILD_FLAGS
# export LIBS="-lm"
# export LIBS="-l:magma.o"
export LDFLAGS="-L$OUT -g"

# if [ -z "$ANDROID" ]; then
# 	export LIBS="-l:magma.o"
# fi

sh ${FUZZER}/instrument.sh