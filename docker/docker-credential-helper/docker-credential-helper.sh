#!/bin/bash

# This script is used to build the credential helpers for Docker using Docker

# install emulators
docker run --privileged --rm tonistiigi/binfmt --install all

# create builder
docker buildx create --use

# build credential helpers from remote repository and output to ./bin/build
docker buildx bake "https://github.com/docker/docker-credential-helpers.git"

# or from local source
git clone https://github.com/docker/docker-credential-helpers.git
cd docker-credential-helpers
docker buildx bake
