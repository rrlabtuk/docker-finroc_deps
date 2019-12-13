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
    ant astyle curl dialog doxygen llvm libclang-dev llvm-dev g++  clang  graphviz make mercurial default-jdk pkg-config 
    
RUN apt-get install -y --no-install-recommends \
    libfontchooser-java libitext5-java libsvgsalamander-java libxstream-java libxpp3-java
    
RUN apt-get install -y --no-install-recommends \
    libboost-all-dev libcppunit-dev  xml2
    
RUN apt-get install -y --no-install-recommends \
    libswitch-perl libterm-readkey-perl libtime-modules-perl libcurses-ui-perl libxml-simple-perl 

USER finroc_user


