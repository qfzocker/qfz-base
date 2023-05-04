#!/bin/bash
set -e

# declaration of variables
# URL of openjdk
OPENJDKDWL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz'

apt-get update
echo " * Install OpenJDK ..."
curl -sSL "$OPENJDKDWL" > openjdk.tar.gz
mkdir -p /opt/openjdk
tar -C /opt/openjdk -xf openjdk.tar.gz
rm -f openjdk.tar.gz
