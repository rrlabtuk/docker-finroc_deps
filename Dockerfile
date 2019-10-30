FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install -y wget software-properties-common bash apt-utils
    
RUN useradd -ms /bin/bash  finroc_user
RUN mkdir -p /home/finroc_user
WORKDIR /home/finroc_user

COPY ./.bashrc /home/finroc_user

VOLUME /home/finroc_user


RUN add-apt-repository universe

RUN apt-get update && \
    apt-get install -y \
    ant astyle curl dialog doxygen llvm libclang-dev llvm-dev g++  clang  graphviz make mercurial default-jdk pkg-config 
    
RUN apt-get install -y \
    libfontchooser-java libitext5-java libsvgsalamander-java libxstream-java libxpp3-java
    
RUN apt-get install -y \
    libboost-all-dev libcppunit-dev  xml2
    
RUN apt-get install -y \
    libswitch-perl libterm-readkey-perl libtime-modules-perl libcurses-ui-perl libxml-simple-perl 



