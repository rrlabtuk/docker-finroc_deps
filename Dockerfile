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

#RUN add-apt-repository universe

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    dirmngr gpg-agent \
    && rm -rf /var/lib/apt/lists/*

# Make sure AGROSY_PUB_KEY is passed as build-arg e.g. `docker build . --build-arg AGROSY_PUB_KEY=<AGROSY_PUB_KEY>`
# On docker hub this variable can be added under "Configure Automated Builds"/"Build Environment Variables"
ARG AGROSY_PUB_KEY

ENV AGROSY_PUB_KEY $AGROSY_PUB_KEY

RUN if [ -z "$AGROSY_PUB_KEY" ] ; then echo 'Environment variable AGROSY_PUB_KEY must be specified. Exiting.'; exit 1;  fi

RUN echo "deb https://agrosy.informatik.uni-kl.de/ubuntu `lsb_release -cs` main" | tee /etc/apt/sources.list.d/agrosy.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $AGROSY_PUB_KEY

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    finroc-dependencies astyle=2.03-1 \
    && apt-mark hold astyle \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable empty so it does not leak into the container
ENV AGROSY_PUB_KEY ""

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    gdbserver gdb \
    && rm -rf /var/lib/apt/lists/* 

RUN mkdir -p /finroc_user_scripts && chown -R finroc_user:finroc_user /finroc_user_scripts && chmod -R 777 /finroc_user_scripts

USER finroc_user

ENV CXXFLAGS='-Wno-misleading-indentation'

COPY ./entrypoint.sh /finroc_user_scripts
COPY ./.bashrc /finroc_user_scripts

ENTRYPOINT ["/finroc_user_scripts/entrypoint.sh"]

CMD /bin/bash
