FROM debian:latest
# RUN apt-get update && apt-get -y upgrade && apt-get install -y openssh-server
# RUN mkdir /var/run/sshd
# RUN chmod 0700 ~
# RUN chmod 0700 ~/.ssh
# Set root password for SSH access (change 'your_password' to your desired password)
# RUN echo 'root:pass' | chpasswd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# EXPOSE 22
# CMD ["/usr/sbin/sshd", "-D"]

RUN mkdir /var/run/sshd; \
    apt install -y openssh-server; \
    sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config; \
    sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config; \
    apt clean;

RUN { \
    echo '#!/bin/bash -eu'; \
    echo 'echo "root:${ROOT_PASSWORD}" | chpasswd'; \
    echo 'exec "$@"'; \
    } > /usr/local/bin/entry_point.sh; \
    chmod +x /usr/local/bin/entry_point.sh;

ENV ROOT_PASSWORD pass

EXPOSE 22

ENTRYPOINT ["entry_point.sh"]
