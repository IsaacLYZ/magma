#!/bin/bash
set -e

##
# Pre-requirements:
# - env FUZZER: path to fuzzer work dir
# - env TARGET: path to target work dir
# - env MAGMA: path to Magma support files
# - env OUT: path to directory where artifacts are stored
# - env CFLAGS and CXXFLAGS must be set to link against Magma instrumentation
# + env ANDROID: if set, we don't need to change compiler
##

if [ -z "$ANDROID" ]; then
	export CC="clang"
	export CXX="clang++"
	export LIBS="$LIBS -l:driver.o  -flto $OUT/libclang_rt.fuzzer_no_main-x86_64.a -lstdc++"
	export CFLAGS="$CFLAGS-fno-sanitize-coverage=stack-depth"
	export CXXFLAGS="$CXXFLAGS -fno-sanitize-coverage=stack-depth"
	export LDFLAGS="$LDFLAGS -fno-sanitize-coverage=stack-depth"
else
	# export LIBS="$LIBS -l:driver.o -flto $OUT/libFuzzer_android_no_main.a -lstdc++ -lm"
	export LIBS="$LIBS -l:driver.o -flto $OUT/libFuzzer_android.a -lstdc++ -lm"
fi

export CFLAGS="$CFLAGS -fsanitize=fuzzer-no-link"
export CXXFLAGS="$CXXFLAGS -fsanitize=fuzzer-no-link"
export LDFLAGS="$LDFLAGS -fsanitize=fuzzer-no-link"

"$MAGMA/build.sh"
"$TARGET/build.sh"

# NOTE: We pass $OUT directly to the target build.sh script, since the artifact
#       itself is the fuzz target. In the case of Angora, we might need to
#       replace $OUT by $OUT/fast and $OUT/track, for instance.
