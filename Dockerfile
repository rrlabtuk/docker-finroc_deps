FROM finrocunofficial/finroc_deps:latest
USER root
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    systemd ssh \
  && rm -rf /var/lib/apt/lists/* \
  && yes password | passwd finroc_user

#RUN  systemctl enable ssh 


USER finroc_user
