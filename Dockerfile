# Image build process uses a builder image to avoid leaking public key into final image layers
FROM ubuntu:bionic as builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget software-properties-common bash apt-utils \
    dirmngr gpg-agent \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Make sure AGROSY_PUB_KEY is passed as build-arg e.g. `docker build . --build-arg AGROSY_PUB_KEY=<AGROSY_PUB_KEY>`
# On docker hub this variable can be added under "Configure Automated Builds"/"Build Environment Variables"
ARG AGROSY_PUB_KEY

ENV AGROSY_PUB_KEY $AGROSY_PUB_KEY

RUN if [ -z "$AGROSY_PUB_KEY" ] ; then echo 'Environment variable AGROSY_PUB_KEY must be specified. Exiting.'; exit 1;  fi

RUN echo "deb https://agrosy.informatik.uni-kl.de/ubuntu `lsb_release -cs` main" | tee /etc/apt/sources.list.d/agrosy.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $AGROSY_PUB_KEY

# Download packages
RUN mkdir -p /install_deb/packages && apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -dy -o=Dpkg::Use-Pty=0 \
    -d -o debug::nolocking=true \
    -o dir::cache=/install_deb \
    finroc-dependencies astyle=2.03-1 \
    && apt-mark hold astyle

# Create a local Repository .gz file
RUN apt-get update && \
    apt-get install -y --no-install-recommends dpkg-dev \
    && cd /install_deb/archives \
    && dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

FROM ubuntu:bionic

# Install some basic tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget software-properties-common bash apt-utils && \
    rm -rf /var/lib/apt/lists/*

# Set some locale related stuff
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

# Create directory to copy packages into
RUN mkdir -p /install_deb

# Copy downloaded packages from builder image
COPY --from=builder /install_deb /install_deb

# Add folder as local repository and install dependencies from there
# To reduce image size add --no-install-recommends to apt-get install
RUN sed  -i '1i deb [trusted=yes] file:/install_deb/archives ./' /etc/apt/sources.list \
    && apt-get update \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y  -o=Dpkg::Use-Pty=0 \
    finroc-dependencies astyle=2.03-1 \
    && apt-mark hold astyle \
    && rm -rf /install_deb \
    && sed '1d' /etc/apt/sources.list > tmpfile; mv tmpfile /etc/apt/sources.list

# Install gdbserver and gdb for remote debugging from outside container
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    gdbserver gdb \
    && rm -rf /var/lib/apt/lists/* 

# Create finrco_user_scripts directory that contains the entrypoint
RUN mkdir -p /finroc_user_scripts && chown -R finroc_user:finroc_user /finroc_user_scripts && chmod -R 777 /finroc_user_scripts

# Switch to user finroc_user from here
USER finroc_user

# Set CXXFLAG that prevents compilation error. Setting the environment variable may not have an effect here
ENV CXXFLAGS='-Wno-misleading-indentation'

# Copy entrypoint and default .bashrc
COPY ./entrypoint.sh /finroc_user_scripts
COPY ./.bashrc /finroc_user_scripts

ENTRYPOINT ["/finroc_user_scripts/entrypoint.sh"]

CMD /bin/bash
