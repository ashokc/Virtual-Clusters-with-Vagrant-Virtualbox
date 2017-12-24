#!/bin/bash

export JAVA_HOME=/opt/software/java/jdk1.8.0_65
export ES_HOME=/opt/software/elasticsearch/elasticsearch-1.7.2
export ES_HEAP_SIZE=2g

cluster_name=es-dev
http_port=9210
transport_port=9310
host_name=localhost
node_name=node0

path_work=$ES_HOME/tmp
path_data=$ES_HOME/data
path_config=$ES_HOME/config
path_logs=$ES_HOME/logs
path_plugins=$ES_HOME/plugins
pid_file=$ES_HOME/pid

echo "$ES_HOME/bin/elasticsearch -d -Des.cluster.name=$cluster_name -Des.node.name=$node_name -Des.http.port=$http_port -Des.transport.tcp.port=$transport_port -Des.path.data=$path_data -Des.path.logs=$path_logs -Des.path.plugins=$path_plugins -Des.path.conf=$path_config -Des.path.work=$path_work -Des.network.host=$host_name -Des.network.publish_host=$host_name -p $pid_file"

$ES_HOME/bin/elasticsearch -d -Des.cluster.name=$cluster_name -Des.node.name=$node_name -Des.http.port=$http_port -Des.transport.tcp.port=$transport_port -Des.path.data=$path_data -Des.path.logs=$path_logs -Des.path.plugins=$path_plugins -Des.path.conf=$path_config -Des.path.work=$path_work -Des.network.host=$host_name -Des.network.publish_host=$host_name -p $pid_file

