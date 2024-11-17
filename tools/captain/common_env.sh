#!/bin/bash -e

# Environment variables for magma
# env MAGMA_R: path to magma root
# env OUT: target build directory
# env SHARED:
# env MAGMA: path to magma component
export MAGMA_R=$MAGMA_R
export OUT=$MAGMA_R/magma_out
export SHARED=$MAGMA_R/magma_shared
export MAGMA=$MAGMA_R/magma

# Compiler settings for local environment
export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
export LD=/usr/bin/ld
export AR=/usr/bin/ar
export AS=/usr/bin/as
export NM=/usr/bin/nm
export RANLIB=/usr/bin/ranlib