FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget software-properties-common bash apt-utils && \
    rm -rf /var/lib/apt/lists/*
    
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*
    
ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8
    
RUN useradd -ms /bin/bash  finroc_user
RUN mkdir -p /home/finroc_user
WORKDIR /home/finroc_user

COPY ./.bashrc /home/finroc_user

VOLUME /home/finroc_user


RUN add-apt-repository universe

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
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
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
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
    
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    qt5-default libqt4-dev-bin \
    && rm -rf /var/lib/apt/lists/* 
    
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
	freeglut3-dev \
    && rm -rf /var/lib/apt/lists/* 
    
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    libacl1 libapt-pkg5.0 libatlas-base-dev libattr1 libaudit-common libaudit1 libavcodec-extra libblkid1 \
    libbz2-1.0 libc-bin libc6 libcaffe-cuda-dev libcap-ng0 libcom-err2 libcommons-collections3-java \
    libcommons-collections4-java libdb5.3 libdebconfclient0 libdxflib-dev libdynamicedt3d-dev libeigen3-dev \
    libelf-dev libext2fs2 libfdisk1 libffi6 libflann-dev libganymed-ssh2-java libgcc1 libgcrypt20 libgflags-dev libglew-dev \
    libgmp10 libgnutls30 libgomp1 libgpg-error0 libgps-dev libgsl-dev libhidapi-libusb0 libhogweed4 libidn2-0 \
    libjung-free-java liblz4-1 liblzma5 libmatio-dev libmount1 libmrpt-dev libncurses5 libncursesw5 libnettle6 \
    liboctomap-dev \
    libomp5 libp11-kit0 libpam-modules libpam-modules-bin libpam-runtime libpam0g libpcl-dev \
    libpcre3 libpng16-16 libprocps6 libprotobuf-dev libqt4-dev-bin \
    libseccomp2 libselinux1 libsemanage-common libsemanage1 libsepol1 \
    libsimage-dev libsmartcols1 libss2 libstdc++6 libsystemd0 libtasn1-6 libtinfo5 libturbojpeg libudev1 libunistring2 \
    libusb-1.0-0-dev libuuid1 libuvc-dev libuvc0 \
	&& rm -rf /var/lib/apt/lists/* 


RUN mkdir -p /finroc_user_scripts && chown -R finroc_user:finroc_user /finroc_user_scripts && chmod -R 777 /finroc_user_scripts

USER finroc_user

ENV CXXFLAGS='-Wno-misleading-indentation'

COPY ./entrypoint.sh /finroc_user_scripts
COPY ./.bashrc /finroc_user_scripts

ENTRYPOINT ["/finroc_user_scripts/entrypoint.sh"]

CMD /bin/bash
