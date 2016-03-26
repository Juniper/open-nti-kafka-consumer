# Telegraf configuration

# Telegraf is entirely plugin driven. All metrics are gathered from the
# declared inputs, and sent to the declared outputs.

# Plugins must be declared in here to be active.
# To deactivate a plugin, comment out the name and any variables.

# Use 'telegraf -config telegraf.conf -test' to see what metrics a config
# file would generate.

# Global tags can be specified here in key="value" format.
[tags]
  # dc = "us-east-1" # will tag all metrics with dc=us-east-1
  # rack = "1a"

# Configuration for telegraf agent
[agent]
  # Default data collection interval for all inputs
  interval = "10s"
  # Rounds collection interval to 'interval'
  # ie, if interval="10s" then always collect on :00, :10, :20, etc.
  round_interval = true

  # Telegraf will cache metric_buffer_limit metrics for each output, and will
  # flush this buffer on a successful write.
  metric_buffer_limit = 10000

  # Collection jitter is used to jitter the collection by a random amount.
  # Each plugin will sleep for a random time within jitter before collecting.
  # This can be used to avoid many plugins querying things like sysfs at the
  # same time, which can have a measurable effect on the system.
  collection_jitter = "0s"

  # Default data flushing interval for all outputs. You should not set this below
  # interval. Maximum flush_interval will be flush_interval + flush_jitter
  flush_interval = "10s"
  # Jitter the flush interval by a random amount. This is primarily to avoid
  # large write spikes for users running a large number of telegraf instances.
  # ie, a jitter of 5s and interval 10s means flushes will happen every 10-15s
  flush_jitter = "0s"

  # Run telegraf in debug mode
  debug = false
  # Run telegraf in quiet mode
  quiet = false
  # Override default hostname, if empty use os.Hostname()
  hostname = ""

###############################################################################
#                                  OUTPUTS                                    #
###############################################################################


# Configuration for influxdb server to send metrics to
[[outputs.influxdb]]
  # The full HTTP or UDP endpoint URL for your InfluxDB instance.
  # Multiple urls can be specified but it is assumed that they are part of the same
  # cluster, this means that only ONE of the urls will be written to each interval.
  # urls = ["udp://localhost:8089"] # UDP endpoint example
  urls = ["http://{{ INFLUXDB_ADDR }}:{{ INFLUXDB_PORT}}"] # required
  # The target database for metrics (telegraf will create it if not exists)
  database = "{{ INFLUXDB_DB }}" # required
  username = "{{ INFLUXDB_USER }}"
  password = "{{ INFLUXDB_PWD }}"

  # Precision of writes, valid values are n, u, ms, s, m, and h
  # note: using second precision greatly helps InfluxDB compression
  precision = "s"

  # Connection timeout (for the connection with InfluxDB), formatted as a string.
  # If not provided, will default to 0 (no timeout)
  # timeout = "5s"

  # Set the user agent for HTTP POSTs (can be useful for log differentiation)
  # user_agent = "telegraf"
  # Set UDP payload size, defaults to InfluxDB UDP Client default (512 bytes)
  # udp_payload = 512

###############################################################################
#                                  INPUTS                                     #
###############################################################################

# Read metrics from Kafka topic(s)
[[inputs.kafka_consumer]]
  ## topic(s) to consume
  topics = ["{{ KAFKA_TOPIC }}"]
  name_override = "{{ KAFKA_TOPIC }}"

  ## an array of Zookeeper connection strings
  zookeeper_peers = ["{{ ZOOKEEPER_ADDR }}:{{ ZOOKEEPER_PORT }}"]
  ## the name of the consumer group
  consumer_group = "telegraf_metrics_consumers"
  ## Maximum number of metrics to buffer between collection intervals
  metric_buffer = 100000
  ## Offset (must be either "oldest" or "newest")
  offset = "oldest"

  tag_keys = [
    "device",
    "type",
    "interface"
  ]

  ## Data format to consume. This can be "json", "influx" or "graphite"
  ## Each data format has it's own unique set of configuration options, read
  ## more about them here:
  ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
  data_format = "{{ KAFKA_DATA_TYPE }}"
