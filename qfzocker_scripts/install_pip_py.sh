#!/bin/bash
set -e

apt-get update

# install python packages
apt-get install -y --no-install-recommends \
    python \
    python-pip \
    python-numpy \
    python-pandas \
    python-dev \
    python3-pip

# install python modules
/usr/bin/pip3 install pandas
/usr/bin/pip3 install numpy
/usr/bin/pip3 install xlrd
/usr/bin/pip3 install openpyxl
/usr/bin/pip3 install sympy
/usr/bin/pip3 install matplotlib
/usr/bin/pip3 install seaborn
