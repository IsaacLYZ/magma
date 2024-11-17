#!/bin/bash
set -e

##
# Pre-requirements:
# - env TARGET: path to target work dir
# - env OUT: path to directory where artifacts are stored
# - env CC, CXX, FLAGS, LIBS, etc...
##

if [ ! -d "$TARGET/repo" ]; then
    echo "fetch.sh must be executed first."
    exit 1
fi

cd "$TARGET/repo"
if [ -n "$ANDROID" ] && [ -n $BUILD_TARGET ]; then
	./autogen.sh \
	--with-http=no \
	--with-python=no \
	--with-lzma=no \
	--with-threads=no \
	--disable-shared \
	--host $BUILD_TARGET$API
	LZMA=""
else
	./autogen.sh \
	--with-http=no \
	--with-python=no \
	--with-lzma=yes \
	--with-threads=no \
	--disable-shared
	LZMA="-llzma"
fi

make -j$(nproc) clean
make -j$(nproc) all

cp xmllint "$OUT/"

for fuzzer in libxml2_xml_read_memory_fuzzer libxml2_xml_reader_for_file_fuzzer; do
  $CXX $CXXFLAGS -std=c++11 -Iinclude/ -I"$TARGET/src/" \
      "$TARGET/src/$fuzzer.cc" -o "$OUT/$fuzzer" \
      .libs/libxml2.a $LDFLAGS $LIBS -lz $LZMA
done
