#!/usr/bin/env bash

nguests=$1
guestNumber=$2
memory=$3
ipAddressStart=$4

# Install some utilities that we will need
apt-get -y install unzip
apt-get -y install curl

# Install java
mkdir -p /opt/software/java
cd /opt/software/java ; tar zxvf /vagrant/tools/jdk-8u65-linux-x64.tar.gz

# Install & Start up elasticsearch
/vagrant/scripts/elastic.sh $nguests $guestNumber $memory $ipAddressStart

