#!/bin/bash -e

git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest

# Activate Emscripten in your current terminal session
source ./emsdk_env.sh  