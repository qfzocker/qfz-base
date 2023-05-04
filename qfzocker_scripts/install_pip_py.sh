#!/bin/bash
set -e

apt-get update

# install python packages
apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3.11-venv \
    python3.11-doc \
    binfmt-support

# make 3.11 the default
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# install python modules
if [[ -f $PIPPYMOD ]];then
  echo " * Pip Install Modules ..."
  for m in $(cat $PIPPYMOD);do
    echo " ** Install $m ..."
    /usr/bin/pip3 install $m
  done
fi
