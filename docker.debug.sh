#! /bin/bash

docker stop open-nti-kafka-consumer_con
docker rm open-nti-kafka-consumer_con

docker run --rm -t \
    -e INFLUXDB_ADDR="open-nti_con" \
    -e ZOOKEEPER_ADDR="kafka_con" \
    --volume $(pwd):/root/telegraf \
    --name open-nti-kafka-consumer_con \
    -i juniper/open-nti-kafka-consumer /sbin/my_init -- bash -l
