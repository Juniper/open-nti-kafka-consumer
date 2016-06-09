#! /bin/bash

docker stop open-nti-kafka-consumer_con
docker rm open-nti-kafka-consumer_con

docker run --rm -t \
    -e INFLUXDB_ADDR="172.29.103.199" \
    -e ZOOKEEPER_ADDR="172.29.103.199" \
    -e KAFKA_TOPIC="events" \
    --name open-nti-kafka-consumer_con \
    -i juniper/open-nti-kafka-consumer
