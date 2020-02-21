FROM finrocunofficial/finroc_deps:latest

USER root

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

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    ann-tools libarchive-dev libaria-dev asn1c libassimp-dev  libcg3-dev \
    curl libdb++-dev  gpsd python-nmea2 libjsoncpp-dev liboctomap1.8 libvtk6-dev libqt5opengl5-dev \
    libmatio-dev \
    && rm -rf /var/lib/apt/lists/* 

# Not available on bionic:    
#    liborocos-bfl-dev carla

USER finroc_user
