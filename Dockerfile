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
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0\
    ant curl dialog doxygen llvm libclang-dev llvm-dev g++ clang graphviz make mercurial default-jdk pkg-config \
    subversion \
    libfontchooser-java libitext5-java libsvgsalamander-java libxstream-java libxpp3-java \
    openjdk-11-jdk libjung-free-java libcommons-collections4-java libganymed-ssh2-java \
    libganymed-ssh2-java libjogl2-java \
    libboost-all-dev libcppunit-dev  libxml2-dev xml2  libjpeg-turbo8-dev libreadline-dev \
    libswitch-perl libterm-readkey-perl libtime-modules-perl libcurses-ui-perl libxml-simple-perl \
    libespeak-dev libestools2.1-dev festival-dev \
    g++-8 libgcc-8-dev  && \
    rm -rf /var/lib/apt/lists/*  
    
RUN add-apt-repository universe && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0\
    libcgal-dev libcgal13 libcgal-qt5-dev libcgal-ipelets libcgal-qt5-13 libcgal-demo \
    libopencv-dev libomp-dev  && \
    rm -rf /var/lib/apt/lists/*  
        
COPY ./astyle_2.03-1_amd64.deb /var/cache/apt/archives/astyle_2.03-1_amd64.deb
RUN yes | dpkg -i /var/cache/apt/archives/astyle_2.03-1_amd64.deb && \
    apt-mark hold astyle && \
    rm -rf /var/lib/apt/lists/*  
    
COPY ./libui-dialog-perl_1.09-1_all.deb /var/cache/apt/archives/libui-dialog-perl_1.09-1_all.deb
RUN yes | dpkg -i /var/cache/apt/archives/libui-dialog-perl_1.09-1_all.deb && \
    rm -rf /var/lib/apt/lists/*  


USER finroc_user

ENV CXXFLAGS='-Wno-misleading-indentation'
