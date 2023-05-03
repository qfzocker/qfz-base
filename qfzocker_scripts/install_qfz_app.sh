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

