FROM phusion/baseimage:0.9.18
MAINTAINER Damien Garros <dgarros@gmail.com>

RUN     apt-get -y update && \
        apt-get -y upgrade && \
        apt-get clean   && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# dependencies
RUN     apt-get -y update && \
        apt-get -y install \
              git \
              adduser \
              libfontconfig \
              wget \
              make \
              curl \
              build-essential \
              tcpdump \
              python-dev \
              python-pip

        #       && \
        # apt-get clean && \
        # rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN     pip install envtpl

# Latest version
ENV TELEGRAF_VERSION 0.11.1-1

########################
### Install telegraf ###
########################

RUN     curl -s -o /tmp/telegraf_latest_amd64.deb http://get.influxdb.org/telegraf/telegraf_${TELEGRAF_VERSION}_amd64.deb && \
        dpkg -i /tmp/telegraf_latest_amd64.deb && \
        rm /tmp/telegraf_latest_amd64.deb

RUN     mkdir /root/telegraf

RUN     mkdir /etc/service/telegraf
ADD     telegraf/telegraf.launcher.sh /etc/service/telegraf/run
RUN     chmod +x /etc/service/telegraf/run

ADD     telegraf/telegraf.start.sh /root/telegraf.start.sh
RUN     chmod +x /root/telegraf.start.sh

########################
### Configuration    ###
########################

WORKDIR /root
ENV HOME /root

RUN chmod -R 777 /var/log/

ENV INFLUXDB_ADDR=localhost \
    INFLUXDB_DB=juniper \
    INFLUXDB_USER=juniper \
    INFLUXDB_PWD=juniper \
    INFLUXDB_PORT=8086 \
    ZOOKEEPER_ADDR=localhost \
    ZOOKEEPER_PORT=2181 \
    KAFKA_TOPIC=jnpr.jvision \
    KAFKA_DATA_TYPE=json

CMD ["/sbin/my_init"]
