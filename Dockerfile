FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget software-properties-common bash apt-utils
    
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8
    
RUN useradd -ms /bin/bash  finroc_user
RUN mkdir -p /home/finroc_user
WORKDIR /home/finroc_user

COPY ./.bashrc /home/finroc_user

VOLUME /home/finroc_user


RUN add-apt-repository universe

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ant astyle curl dialog doxygen llvm libclang-dev llvm-dev  gcc-8-base g++  clang-7  graphviz make mercurial default-jdk pkg-config 
    
RUN apt-get install -y --no-install-recommends \
    libfontchooser-java libitext5-java libsvgsalamander-java libxstream-java libxpp3-java \
    openjdk-11-jdk libjung-free-java libcommons-collections4-java libganymed-ssh2-java \
    libganymed-ssh2-java libjogl2-java
    
RUN apt-get install -y --no-install-recommends \
    libboost-all-dev libcppunit-dev  xml2  libjpeg-turbo8-dev libreadline-dev
    
RUN apt-get install -y --no-install-recommends \
    libswitch-perl libterm-readkey-perl libtime-modules-perl libcurses-ui-perl libxml-simple-perl 

RUN apt-get install -y --no-install-recommends \
    caffe-cuda caffe-tools-cuda dvipng freeglut3-dev gsl-bin minicom mrpt-apps
    
RUN apt-get install -y --no-install-recommends \
    lib-nite2-dev libacl1 libatlas-base-dev libattr1 libaudit-common libaudit1 libavcodec-extra libblkid1 libboost-dev \
    libbz2-1.0 libc-bin libc6 libcaffe-cuda-dev libcap-ng0 libcgal-dev libcom-err2 libcommons-collections3-java libcommons-collections4-java \
    libdb5.3 libdebconfclient0 libdxflib-dev libdynamicedt3d-dev libeigen3-dev libelf-dev libext2fs2 libfdisk1 libffi6 libflann-dev libganymed-ssh2-java \
    libgcc1 libgcrypt20 libgflags-dev libglew-dev libgmp10 libgnutls30 libgomp1 libgpg-error0 libgps-dev libgsl-dev libhidapi-libusb0 \
    libhogweed4 libidn2-0 libjung-free-java liblz4-1 liblzma5 libmatio-dev libmount1 libmrpt-dev libncurses5 libncursesw5 libnettle6 \
    libnewton-dev libnmea-dev libo3d3xx-camera libo3d3xx-framegrabber libo3d3xx-image libo3d3xx-pcicclient liboctomap-dev libogdf-dev \
    libomp-dev libomp5 libopencv-dev libp11-kit0 libpam-modules libpam-modules-bin libpam-runtime libpam0g libpcl-dev libpcre3 libpng16-16 \
    libprocps6 libprotobuf-dev libqt4-dev-bin libseccomp2 libselinux1 libsemanage-common libsemanage1 libsepol1 libsimage-dev libsmartcols1 libss2 \
    libstdc++6 libsystemd0 libtasn1-6 libtinfo5 libturbojpeg libudev1 libunistring2 libusb-1.0-0-dev libuuid1 libuvc-dev libuvc0
    
RUN apt-get install -y --no-install-recommends \
    coreutils base-files bsdutils findutils gpgv gpsd grep linux-generic-hwe-18.04 linux-headers-generic lld-7 llvm-7-dev mawk \
    sonnet-plugins swi-prolog virtualenv xdot z3 zlib1g
    
USER finroc_user
