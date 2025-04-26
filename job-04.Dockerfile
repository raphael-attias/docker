FROM debian:stable-slim
RUN apt-get update && apt-get install -y openssh-server \
    && mkdir /var/run/sshd \
    && echo 'root:root123' | chpasswd
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]