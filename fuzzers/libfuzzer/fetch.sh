#!/bin/bash
set -e

##
# Pre-requirements:
# - env FUZZER: path to fuzzer work dir
##

if [ -n "$ANDROID" ] && [ -z "$TOOLCHAIN" ]; then
	echo "tools/captain/android_env.sh must be run using source before running libfuzzer/fetch.sh"
	exit 1
fi

if [ -n "$ANDROID" ] && [ ! -d $FUZZER/repo_android ]; then
	# Checkout llvm for Android
	git clone --no-checkout https://android.googlesource.com/toolchain/llvm-project "$FUZZER/repo_android"
	# Retrieve the commit hash from Android clang
	COMMIT=$($TOOLCHAIN/bin/clang --version | grep -o 'https://android.googlesource.com/toolchain/llvm-project [^)]*' | sed 's|.* ||')
	echo "Checking out to Android llvm commit $COMMIT"
	git -C "$FUZZER/repo_android" checkout $COMMIT
else
	# Checkout normal llvm
	git clone --no-checkout https://github.com/llvm/llvm-project.git "$FUZZER/repo"
	git -C "$FUZZER/repo" checkout 29cc50e17a6800ca75cd23ed85ae1ddf3e3dcc14
fi