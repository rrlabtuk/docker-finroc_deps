FROM ubuntu:eoan

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget software-properties-common bash apt-utils
    
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
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


