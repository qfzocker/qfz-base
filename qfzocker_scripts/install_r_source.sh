#!/bin/bash

### # This script is based on the installation script from the rocker project
### # See https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_R_source.sh 
### # for the original version. 

## Install R from source.
##
## In order of preference, first argument of the script, the R_VERSION variable.
## ex. latest, devel, patched, 4.0.0
##
## 'devel' means the prerelease development version (Latest daily snapshot of development version).
## 'patched' means the prerelease patched version (Latest daily snapshot of patched version).

set -e

R_VERSION=${1:-${R_VERSION:-"latest"}}
R_HOME=${R_HOME:-"/usr/local/lib/R"}
CRAN=${CRAN:-"https://cloud.r-project.org"}

# shellcheck source=/dev/null
source /etc/os-release

apt-get update
apt-get -y install locales

## Configure default locale
LANG=${LANG:-"en_US.UTF-8"}
/usr/sbin/locale-gen --lang "${LANG}"
/usr/sbin/update-locale --reset LANG="${LANG}"

export DEBIAN_FRONTEND=noninteractive

READLINE_VERSION=8
if [ "${UBUNTU_CODENAME}" == "bionic" ]; then
    READLINE_VERSION=7
fi

apt-get install -y --no-install-recommends \
    bash-completion \
    ca-certificates \
    curl \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    gsfonts \
    libblas-dev \
    libbz2-* \
    libcurl4 \
    libcurl4-openssl-dev \
    libgit2-dev \
    "libicu[0-9][0-9]" \
    liblapack-dev \
    libpcre2* \
    libjpeg-turbo* \
    libpangocairo-* \
    libpng16* \
    "libreadline${READLINE_VERSION}" \
    libssl-dev \
    libtiff* \
    liblzma* \
    libxml2-dev \
    libbz2-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libicu-dev \
    libpcre2-dev \
    libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    liblzma-dev \
    libx11-dev \
    libxt-dev \
    make \
    perl \
    tzdata \
    unzip  \
    wget \
    zip \
    zlib1g \
    zlib1g-dev

BUILDDEPS="default-jdk \
    devscripts \
    rsync \
    subversion \
    tcl-dev \
    tk-dev \
    texinfo \
    texlive-extra-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-recommended \
    texlive-latex-extra \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb"

# shellcheck disable=SC2086
apt-get install -y --no-install-recommends ${BUILDDEPS}

## Download R from 0-Cloud CRAN mirror or CRAN or an specified CRAN mirror specified in dockerfile
function download_r_src() {
    wget "https://cloud.r-project.org/src/$1" -O "R.tar.gz" ||
        wget "https://cran.r-project.org/src/$1" -O "R.tar.gz" ||
        wget "${CRAN}/src/$1" -O "R.tar.gz"
}

if [ "$R_VERSION" == "devel" ]; then
    download_r_src "base-prerelease/R-devel.tar.gz"
elif [ "$R_VERSION" == "patched" ]; then
    download_r_src "base-prerelease/R-latest.tar.gz"
elif [ "$R_VERSION" == "latest" ]; then
    download_r_src "base/R-latest.tar.gz"
else
    download_r_src "base/R-${R_VERSION%%.*}/R-${R_VERSION}.tar.gz"
fi

tar xzf "R.tar.gz"
cd R-*/

R_PAPERSIZE=a4 \
    R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    ./configure --enable-R-shlib \
    --enable-memory-profiling \
    --with-readline \
    --with-blas \
    --with-lapack \
    --with-tcltk \
    --with-recommended-packages

make
make install
make clean

## Add a library directory (for user-installed packages)
mkdir -p "${R_HOME}/site-library"
chown root:staff "${R_HOME}/site-library"
chmod g+ws "${R_HOME}/site-library"

## Fix library path
echo "R_LIBS=\${R_LIBS-'${R_HOME}/site-library:${R_HOME}/library'}" >>"${R_HOME}/etc/Renviron.site"

## Install littler
R -q -e "install.packages(\"littler\", dependencies=TRUE, repo=\"${CRAN}\")"
ln -s /usr/local/lib/R/site-library/littler/bin/r /usr/local/bin/r
ln -s /usr/local/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r

## Clean up from R source install
cd ..
rm -rf /tmp/*
rm -rf R-*/
rm -rf "R.tar.gz"

## Copy the checkbashisms script to local before remove devscripts package.
## https://github.com/rocker-org/rocker-versioned2/issues/510
cp /usr/bin/checkbashisms /usr/local/bin/checkbashisms

# shellcheck disable=SC2086
apt-get remove --purge -y ${BUILDDEPS}
apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*

# Check the R info
echo -e "Check the R info...\n"
R -q -e "sessionInfo()"
echo -e "\nInstall R from source, done!"

# Install CRAN Packages
if [[ -f $CRANPKG ]];then
  echo " * Install CRAN packages ..."
  install2.r -r $CRAN $(cat $CRANPKG | sed -z "s/\n/ /g")
  echo " * Check installed packages ..."
  for p in $(cat $CRANPKG);do
    R -q -e "is.element(\"${p}\", installed.packages())"
  done
fi

