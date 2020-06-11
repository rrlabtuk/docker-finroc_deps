FROM finrocunofficial/finroc_deps:latest
USER root
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    ssh \
  && rm -rf /var/lib/apt/lists/* \
  && yes password | passwd finroc_user
  
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    supervisor \
    && rm -rf /var/lib/apt/lists/*
    
RUN mkdir /var/run/sshd
ADD sshd.conf /etc/supervisor/conf.d/sshd.conf

ADD start_ssh.sh /finroc_user_scripts/start_ssh.sh
RUN chmod 0755 /start.sh

EXPOSE 22

CMD /start_ssh.sh


