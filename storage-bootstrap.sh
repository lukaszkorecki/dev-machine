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
  openjdk-7-jre-headless \
  elasticsearch \
  postgresql-contrib-9.3

if test -e /usr/share/elasticsearch/plugins/kopf ; then
  echo 'kopf already installed'
else

  cd /usr/share/
  ./elasticsearch/bin/plugin --install lmenezes/elasticsearch-kopf/
fi

apt-get remove ufw -y
apt-get autoremove -y


if grep '^listen_addresses = ' /etc/postgresql/9.3/main/postgresql.conf ; then
  echo 'pg already set up'
else
  echo 'listen_addresses = "*"' >> /etc/postgresql/9.3/main/postgresql.conf
  echo 'host    all             all             0.0.0.0/0              md5' >> /etc/postgresql/9.3/main/pg_hba.conf
  service postgressql restart || service postgressql start
fi
