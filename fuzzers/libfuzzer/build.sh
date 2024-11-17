#!/bin/bash
set -e

##
# Pre-requirements:
# - env FUZZER: path to fuzzer work dir
# - env OUT: target build directory
# + env ANDROID: if set, we only copy prebuilt libraries from Android NDK
##

if [ -n "$ANDROID" ]; then
	cd "$FUZZER/repo_android/compiler-rt/lib/fuzzer"
	for f in *.cpp; do
		#$CXX $CXXFLAGS -stdlib=libstdc++ -fPIC -O2 -std=c++11 $f -c &
		$CXX -g -O2 -fno-omit-frame-pointer $f -c &
	done && wait
	if [ -f $OUT/libFuzzer_android.a ]; then
		rm $OUT/libFuzzer_android.a
	fi
	ar r "$OUT/libFuzzer_android.a" *.o
else
	# We need the version of LLVM which has the LLVMFuzzerRunDriver exposed
	cd "$FUZZER/repo/compiler-rt/lib/fuzzer"
	for f in *.cpp; do
		clang++ -stdlib=libstdc++ -fPIC -O2 -std=c++11 $f -c &
	done && wait
	if [ -f $OUT/libFuzzer.a ]; then
		rm $OUT/libFuzzer.a
	fi
	ar r "$OUT/libFuzzer.a" *.o
fi

$CXX $CXXFLAGS -std=c++11 -c "$FUZZER/src/driver.cpp" -fPIC -o "$OUT/driver.o"