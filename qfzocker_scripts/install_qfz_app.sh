#!/bin/bash
set -e

# install R from source
if [[ -f $INSTRSRC ]];then
  echo " * Running $INSTRSRC ..."
  $INSTRSRC
fi

# install python
if [[ -f $INSTPYPKG ]];then
  echo " * Running $INSTPYPKG ..."
  $INSTPYPKG
fi

# install Julia
if [[ -f $INSTJULIA ]];then
  echo " * Running $INSTJULIA ..."
  $INSTJULIA
fi

# install openjdk
if [[ -f $INSTOPENJDK ]];then
  echo " * Running $INSTOPENJDK ..."
  $INSTOPENJDK
fi
