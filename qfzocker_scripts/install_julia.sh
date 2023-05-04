#!/bin/bash
set -e

# declaration of variables
# julia download url copied from https://julialang.org/downloads/
JULIADWL=https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.5-linux-x86_64.tar.gz

apt-get update
echo " * Install Julia ..."
curl -sSL "$JULIADWL" > julia.tar.gz
mkdir -p /opt/julia
tar -C /opt/julia -zxf julia.tar.gz
rm -f julia.tar.gz
