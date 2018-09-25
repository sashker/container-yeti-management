#!/bin/bash -l

set -e

# Use local cache proxy if it can be reached, else nothing.
eval $(detect-proxy enable)

log::m-info "We have to create user $USER"
build::user::create $USER

log::m-info "Installing essentials ..."
apt-get update -qq
apt-get install -yqq \
    ca-certificates \
	iputils-ping \
    libprotobuf-dev \
    libnanomsg-dev \
    libconfuse-dev \
    build-essential \
    cmake \
    protobuf-compiler \
    pkg-config \
    libsctp1 \
    libsctp-dev \
    libevent-2.0-5 \
    libevent-dev \
    git

log::m-info "Creating the config directory ..."
mkdir /etc/yeti

log::m-info "Cloning the project repo ..."
cd /tmp
git clone -b $BRANCH $REPO

log::m-info "Making the necessary build directory ..."
cd yeti-management
mkdir build && cd build

log::m-info "Compiling the project ..."
cmake ..

log::m-info "Installing files of the project ..."
make install

log::m-info "Removing unnecessary packages..."
apt-get purge -y --auto-remove git build-essential cmake protobuf-compiler pkg-config

log::m-info "Cleaning up ..."
apt-clean --aggressive
rm -rf /tmp/yeti-management

# if applicable, clean up after detect-proxy enable
eval $(detect-proxy disable)

rm -r -- "$0"
