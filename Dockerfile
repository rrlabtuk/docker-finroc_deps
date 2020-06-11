FROM finrocunofficial/finroc_deps:latest
USER root
RUN yes password | passwd finroc_user \
  && ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521 \
  && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
  && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa

USER finroc_user
