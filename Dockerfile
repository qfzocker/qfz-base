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

# add directory with installation scripts to docker container
ADD qfzocker_scripts /qfzocker_scripts

# run installation script
RUN /qfzocker_scripts/install_qfz_base.sh

