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

if [ -n "$ANDROID" ]; then
	# We need to compile dependencies for Android
	# Compile libncurses
	cd "$TARGET/ncurses"
	./configure --prefix=$TARGET/lib  --disable-shared --host=$BUILD_TARGET$API 
	make -j$(nproc) clean
	make -j$(nproc)
	make install.includes
	make install.libs
	# Compile readline
	cd "$TARGET/readline"
	./configure --host=$BUILD_TARGET$API --disable-shared --enable-static --prefix=$TARGET/lib
	make -j$(nproc) clean
	make -j$(nproc)
	make install
	# Set library path
	CC="$CC -I$TARGET/lib/include"
	LDFLAGS="$LDFLAGS -L$TARGET/lib/lib -lncurses"
fi


# build lua library
cd "$TARGET/repo"
make -j$(nproc) clean
make -j$(nproc) liblua.a

cp liblua.a "$OUT/"

# build driver
make -j$(nproc) lua
cp lua "$OUT/"
