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
    ant curl dialog doxygen llvm libclang-dev llvm-dev g++ clang graphviz make mercurial default-jdk pkg-config \
    subversion 
RUN apt-get install -y --no-install-recommends \
    astyle && \
    apt-mark hold astyle

RUN apt-get install -y --no-install-recommends \
    libfontchooser-java libitext5-java libsvgsalamander-java libxstream-java libxpp3-java \
    openjdk-11-jdk libjung-free-java libcommons-collections4-java libganymed-ssh2-java \
    libganymed-ssh2-java libjogl2-java
    
RUN apt-get install -y --no-install-recommends \
    libboost-all-dev libcppunit-dev  libxml2-dev xml2  libjpeg-turbo8-dev libreadline-dev 
    
RUN apt-get install -y --no-install-recommends \
    libswitch-perl libterm-readkey-perl libtime-modules-perl libui-dialog-perl libcurses-ui-perl libxml-simple-perl 

RUN apt-get install -y --no-install-recommends \
    libespeak-dev libestools2.1-dev festival-dev
    
RUN apt-get install -y --no-install-recommends \
    g++-8 libgcc-8-dev 
    
RUN apt-get install -y --no-install-recommends \
    libcgal-dev libcgal13 libcgal-qt5-dev libcgal-ipelets libcgal-qt5-13 libcgal-demo 

RUN apt-get install -y --no-install-recommends \
    libopencv-dev libomp-dev 
    
RUN apt-get install -y --no-install-recommends \
    libomp-dev 

USER finroc_user

ENV CXXFLAGS='-Wno-misleading-indentation'
