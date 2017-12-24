#!/bin/bash

host_name=localhost
http_port=9210
stopCommand="curl -XPOST http://"$host_name":"$http_port"/_cluster/nodes/_local/_shutdown"
echo "$stopCommand"

$stopCommand

