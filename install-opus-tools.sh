#!/bin/bash

# Install opus-tools
# Latest releases: opus 1.3.1, opus-tools 0.2, opusfile 0.11, libopusenc 0.2.1
# Taken from https://gist.github.com/Nottt/f55dd79ca235d8add67423a76b304961

set -e
set -o pipefail

# Install packages needed

apt update > /dev/null 2>&1 && apt install -y curl libflac-dev > /dev/null 2>&1

# Remove packages that can cause issues

apt -y purge opus* > /dev/null 2>&1 && apt -y purge libopus-dev > /dev/null 2>&1

# Download necessary files

TEMP_FOLDER="$(mktemp -d)"

# Opusfile 0.11
curl -Ls https://downloads.xiph.org/releases/opus/opusfile-0.11.tar.gz | tar xz -C "$TEMP_FOLDER"

# Opus 1.3.1
curl -Ls https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz | tar xz -C "$TEMP_FOLDER"

# Libopusenc 0.2.1
curl -Ls https://archive.mozilla.org/pub/opus/libopusenc-0.2.1.tar.gz | tar xz -C "$TEMP_FOLDER"

# Opus Tools 0.2
curl -Ls https://archive.mozilla.org/pub/opus/opus-tools-0.2.tar.gz | tar xz -C "$TEMP_FOLDER"

# Compile

cd "$TEMP_FOLDER"/opus-1.3.1 || exit

./configure
make -j $(nproc) && make install

cd "$TEMP_FOLDER"/opusfile-0.11 || exit

./configure
make -j $(nproc) && make install

cd "$TEMP_FOLDER"/libopusenc-0.2.1 || exit

./configure
make -j $(nproc) && make install

cd "$TEMP_FOLDER"/opus-tools-0.2 || exit
./configure
make -j $(nproc)
make install
ldconfig

cp "$TEMP_FOLDER"/opus-tools-0.2/opusrtp /usr/local/bin

rm -rf "$TEMP_FOLDER"
