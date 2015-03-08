#!/usr/bin/env bash

set -e

_q() {
  $* > /dev/null
}

curl https://packages.elasticsearch.org/GPG-KEY-elasticsearch > /tmp/es-key
apt-key add /tmp/es-key

add-apt-repository "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main"
apt-get update

apt-get install -y -q elasticsearch \
  postgresql-9.3 \
  redis-server \
  redis-tools
