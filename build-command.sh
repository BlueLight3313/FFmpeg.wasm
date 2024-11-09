#!/bin/bash -e

# Define paths for the current working directory and install location
CURRENT_PATH=$(pwd)
CONT_DIR="${CURRENT_PATH}/contribs"
INSTALL_DIR="${CURRENT_PATH}/output"
BIN_DIR="${INSTALL_DIR}/bin"

# Set up environment for WebAssembly (Emscripten)
export CC=emcc
export CXX=em++
export AR=emar
export RANLIB=ranlib

# Set Emscripten environment (ensure the correct path for your emsdk)
source ../emsdk/emsdk_env.sh

# Prepare PKG_CONFIG_PATH for dependencies
export PKG_CONFIG_PATH="${INSTALL_DIR}/lib/pkgconfig"

echo "PKG_CONFIG_PATH: $PKG_CONFIG_PATH"

# Build libogg for WebAssembly
build_libogg() {
    cd "${CONT_DIR}/libogg-1.3.3"
    emconfigure ./configure --prefix="${INSTALL_DIR}" \
	  # --as=llvm-as \
	  # --ranlib=llvm-ranlib \
	  # --cc=emcc \
	  # --cxx=em++ \
	  # --objcc=emcc \
	  # --dep-cc=emcc
	  
    emmake make
    emmake make install
    cd "${CURRENT_PATH}"
}

# Build libvorbis for WebAssembly
build_libvorbis() {
    cd "${CONT_DIR}/libvorbis-1.3.6"
    emconfigure ./configure --prefix="${INSTALL_DIR}" \
          --as=llvm-as \
	  --ranlib=llvm-ranlib \
	  --cc=emcc \
	  --cxx=em++ \
	  --objcc=emcc \
	  --dep-cc=emcc
	  
    emmake make
    emmake make install
    cd "${CURRENT_PATH}"
}

# Build ffmpeg for WebAssembly
build_ffmpeg() {
    mkdir -p "${BIN_DIR}"

    emconfigure ./configure --prefix="${INSTALL_DIR}" \
        --bindir="${BIN_DIR}" \
        --disable-everything \
        --disable-x86asm \
        --enable-libvorbis \
        --enable-encoder=libvorbis \
        --enable-decoder=pcm_s16le \
        --enable-muxer=ogg \
        --enable-demuxer=wav \
        --enable-protocol=file \
        --enable-muxer=segment \
        --enable-filter=aresample \
        --disable-doc \
        --target-os=none \
        --arch=x86_32 \
        --disable-pthreads \
        --disable-network \
        --disable-sdl2 \
        --disable-iconv \
        --disable-zlib \
        --disable-bzlib \
        --disable-avdevice \
        --disable-avfilter \
        --disable-avcodec \
        --disable-swresample \
        --as=llvm-as \
	--ranlib=llvm-ranlib \
	--cc=emcc \
	--cxx=em++ \
	--objcc=emcc \
	--dep-cc=emcc

    emmake make
    emmake make install
}

# Run the build functions for libogg, libvorbis, and ffmpeg
build_libogg
# build_libvorbis
# build_ffmpeg

