FROM phusion/baseimage:0.9.16
MAINTAINER smdion <me@seandion.com>
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM screen

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Install Dependencies
RUN \
  apt-get update -q && \
  apt-get install -qy apache2 php5 libapache2-mod-php5 wget inotify-tools libapache2-mod-proxy-html && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/*
  
#Volumes and Ports
EXPOSE 80 443
VOLUME ["/config", "/web", "/logs"]

#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
ADD defaults/ /defaults/
RUN chmod -v +x /etc/service/*/run
RUN chmod -v +x /etc/my_init.d/*.sh
 
#Adduser
RUN useradd -u 911 -U -s /bin/false abc
RUN usermod -G users abc
