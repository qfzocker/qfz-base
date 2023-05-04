FROM ubuntu:jammy

LABEL org.opencontainers.image.licenses="The MIT license" \
      org.opencontainers.image.source="https://github.com/qfzocker/qfz-base" \
      org.opencontainers.image.vendor="qfzocker Project" \
      org.opencontainers.image.authors="FB-ZWS Qualitas AG <fbzws.qualitasag@gmail.com>"

# environment
ENV R_VERSION=4.2.3
ENV R_HOME=/usr/local/lib/R
ENV CRAN=https://stat.ethz.ch/CRAN
ENV TZ=Europe/Berlin
# variables that drive the installation of additional apps
ENV INSTRSRC=/qfzocker_scripts/install_r_source.sh
ENV CRANPKG=/qfzocker_scripts/cran_r_pkg.txt
ENV INSTPYPKG=/qfzocker_scripts/install_pip_py.sh
ENV PIPPYMOD=/qfzocker_scripts/pip_py_mod.txt

# add directory with installation scripts to docker container
ADD qfzocker_scripts /qfzocker_scripts

# run installation script
RUN /qfzocker_scripts/install_qfz_app.sh

