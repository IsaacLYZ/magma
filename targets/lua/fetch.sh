#!/bin/bash

##
# Pre-requirements:
# - env TARGET: path to target work dir
##

if [ -n "$ANDROID" ]; then
	# We need to clone libreadline and libncurses as compiling dependencies
	git clone https://git.savannah.gnu.org/git/readline.git
	git clone https://github.com/mirror/ncurses.git
fi

git clone --no-checkout https://github.com/lua/lua.git "$TARGET/repo"
git -C "$TARGET/repo" checkout dbdc74dc5502c2e05e1c1e2ac894943f418c8431