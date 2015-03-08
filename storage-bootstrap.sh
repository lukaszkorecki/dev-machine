#!/usr/bin/env bash

set -e

_q() {
  $* > /dev/null
}

if grep elasticsearch /etc/apt/sources.list; then
  echo "ES installed"
else
  curl https://packages.elasticsearch.org/GPG-KEY-elasticsearch > /tmp/es-key
  apt-key add /tmp/es-key

  add-apt-repository "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main"
  apt-get update
fi

apt-get install -y -q  \
  postgresql-9.3 \
  redis-server \
  redis-tools \
  ufw \
  openjdk-7-jre-headless \
  elasticsearch


cd /usr/share/
./elasticsearch/bin/plugin --install lmenezes/elasticsearch-kopf/

# open up ports
ufw allow ssh
ufw allow 5432
ufw allow 9200
ufw allow 6379
yes | ufw enable
