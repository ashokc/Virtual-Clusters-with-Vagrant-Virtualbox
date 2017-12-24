#!/usr/bin/env bash

usage="Usage: elastic.sh nguests thisguest memory ipAddressStart. Need the number of guests in the cluster, this guest number, es-heap memory in MB like 2048m, and startingIp like 192.168.0.5 if clustered ... "

# Install Elastic,  Configure & Start

function setUnicastHosts() {
  local unicast_guests="discovery.zen.ping.unicast.hosts: ["
  for i in $(seq 1 $nguests); do
#    unicast_guests+='"'$ipAddressStart$i
    unicast_guests+='"guest-es'$i
    unicast_guests+=':9310"'
    if [ "$i" -ne "$nguests" ]; then
      unicast_guests+=','
    fi
  done
  unicast_guests+=']'
  echo "$unicast_guests"
}

# Add to /etc/hosts for convenience & restart networking...
function setEtcHosts() {
  guest_list=""
  for i in $(seq 1 $nguests); do
	  guest_list+=$ipAddressStart$i' guest-es'$i$'\n'
  done
  echo "$guest_list" > guests_to_be_added
  cat /etc/hosts guests_to_be_added > tmp ; mv tmp /etc/hosts
  /etc/init.d/networking restart
}

if [ "$#" -eq 4 ]; then
  nguests=$1
  thisguest=$2
  memory=$(expr $3 / 2)
  memory+="m"
  ES_HEAP_SIZE=$memory
  ipAddressStart=$4

  ES_HOME=/opt/software/elasticsearch/elasticsearch-1.7.2
  mkdir -p /opt/software/elasticsearch
  cd /opt/software/elasticsearch ; unzip /vagrant/tools/elasticsearch-1.7.2.zip

  cp /vagrant/elastic/start-node.sh $ES_HOME
  cp /vagrant/elastic/stop-node.sh $ES_HOME
  cp /vagrant/elastic/elasticsearch.yml $ES_HOME/config

  guest_name="guest-es"$thisguest
  node_name=$guest_name"-node1"
  unicast_guests=$(setUnicastHosts)

  if [ "$thisguest" -eq 1 ]; then
    mkdir -p $ES_HOME/plugins/kopf
    cd $ES_HOME/plugins/kopf ; tar zxvf /vagrant/elastic/kopf.tar.gz
  fi

  perl -0777 -pi -e "s|ES_HOME=/opt/elasticsearch|ES_HOME=$ES_HOME|" $ES_HOME/start-node.sh

  perl -0777 -pi -e "s/ES_HEAP_SIZE=2g/ES_HEAP_SIZE=$memory/" $ES_HOME/start-node.sh

  perl -0777 -pi -e "s/host_name=localhost/host_name=$guest_name/" $ES_HOME/start-node.sh
  perl -0777 -pi -e "s/host_name=localhost/host_name=$guest_name/" $ES_HOME/stop-node.sh

  perl -0777 -pi -e "s/node_name=node0/node_name=$node_name/" $ES_HOME/start-node.sh

  perl -0777 -pi -e "s/$/\n$unicast_guests/" $ES_HOME/config/elasticsearch.yml
else
  echo $usage
  exit 1
fi

setEtcHosts
$ES_HOME/start-node.sh

