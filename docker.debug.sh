#! /bin/bash

docker stop open-nti-kafka-consumer_con
docker rm open-nti-kafka-consumer_con

docker run --rm -t \
        -e OUTPUT_STDOUT="true" \
        -e INFLUXDB_ADDR="172.29.110.16" \
        -e KAFKA_ADDR="172.29.110.16" \
        -e KAFKA_TOPIC="jnpr.analyticsd" \
        -v $(pwd)/plugins:/fluentd/plugins \
        -v $(pwd)/fluent.conf:/fluentd/etc/fluent.conf \
        --name open-nti-kafka-consumer_con \
        -i juniper/open-nti-kafka-consumer:fluentd
