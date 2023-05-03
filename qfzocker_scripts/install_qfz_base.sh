#!/bin/bash
set -e

# install R from source
if [[ -f $INSTRSRC ]];then
  echo " * Running install_r_source.sh ..."
  $INSTRSRC
fi

