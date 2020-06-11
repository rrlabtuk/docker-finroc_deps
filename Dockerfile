FROM finrocunofficial/finroc_deps:latest
USER root
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o=Dpkg::Use-Pty=0 \
    systemd ssh \
  && rm -rf /var/lib/apt/lists/* \
  && systemctl enable ssh
  && systemctl start ssh
  && yes password | passwd finroc_user \
  && ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521 \
  && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
  && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa



USER finroc_user
