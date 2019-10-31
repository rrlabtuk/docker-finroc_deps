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

RUN apt-get install -y --no-install-recommends  gpg-agent

COPY ./finroc.org.list /etc/apt/sources.list.d/finroc.org.list

RUN wget -qO - http://finroc.org/apt-signing-key.gpg | apt-key add -

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    finroc-dependencies astyle=2.03-1 && \
    apt-mark hold astyle



