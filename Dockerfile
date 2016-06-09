FROM telegraf:0.13.0
MAINTAINER Damien Garros <dgarros@gmail.com>

RUN     apt-get -y update && \
        apt-get -y install \
              python-dev \
              python-pip

        #       && \
        # apt-get clean && \
        # rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN     pip install envtpl


########################
### Install telegraf ###
########################

RUN     mkdir /root/telegraf

# RUN     mkdir /etc/service/telegraf
# ADD     telegraf/telegraf.launcher.sh /etc/service/telegraf/run
# RUN     chmod +x /etc/service/telegraf/run

ADD     telegraf.start.sh /root/telegraf.start.sh
RUN     chmod +x /root/telegraf.start.sh

ADD     telegraf.conf.tpl /root/telegraf/telegraf.conf.tpl

# etc/telegraf/telegraf.conf

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

CMD ["/root/telegraf.start.sh"]
