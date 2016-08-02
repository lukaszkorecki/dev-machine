#!/usr/bin/env bash

if [[ -e /vagrant ]] ; then
  echo "!!! Running in vagrant, no need for sudo su"
else
  echo  "!!! Running on real machine, forcing sudo mode"
  sudo su
fi

log() {
  logger -s -t PROVISIONER -- "$*" 2>&1
}

_q() {
  log "> $*"
  $* > /dev/null
}


export DEBIAN_FRONTEND=noninteractive
set -e

apt-add-repository ppa:openjdk-r/ppa
apt update
apt-get install -y -q  openjdk-8-jdk openjdk-8-jre

if grep elasticsearch /etc/apt/sources.list; then
  log "ES installed"
else
  curl https://packages.elasticsearch.org/GPG-KEY-elasticsearch > /tmp/es-key
  apt-key add /tmp/es-key

  add-apt-repository "deb http://packages.elasticsearch.org/elasticsearch/2.x/debian stable main"
  apt update
fi

if grep rabbitmq /etc/apt/sources.list ; then
  log 'Rabbit installed'
else
  curl https://www.rabbitmq.com/rabbitmq-release-signing-key.asc > /tmp/rabbit-key
  apt-key add /tmp/rabbit-key

  add-apt-repository 'deb http://www.rabbitmq.com/debian/ testing main'
  apt update
fi

if grep postgresql  /etc/apt/sources.list ; then
  log 'PG installed'
else
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc > /tmp/pg-key
  apt-key add /tmp/pg-key

  add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"
  apt update
fi

if grep rethinkdb /etc/apt/sources.list ; then
    log 'rethinkdb installed'
else
    curl -L https://download.rethinkdb.com/apt/pubkey.gpg > /tmp/rethink-key
    apt-key add /tmp/rethink-key
    add-apt-repository "deb http://download.rethinkdb.com/apt trusty main"
    apt update
fi

apt-get install -y -q  \
  ntp \
  ufw \
  htop \
  postgresql-9.4 \
  redis-server \
  redis-tools \
  elasticsearch \
  rabbitmq-server \
  postgresql-contrib-9.4 \
  redis-server \
  rethinkdb

if test -e /usr/share/elasticsearch/plugins/kopf ; then
  log 'kopf already installed'
else

  cd /usr/share/
  ./elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf/
fi

# add stopwords to ES
if test -e /etc/elasticsearch/stopwords ; then
  log 'ES stopwords already present'
else
  mkdir -p /etc/elasticsearch/stopwords/en_stop_filter
  wget -O /etc/elasticsearch/stopwords/en_stop_filter/stopwords.txt https://nomnom-assets.s3.amazonaws.com/nlp/stopwords/en_stop_filter/stopwords.txt
fi

# make sure ES listens on 0.0.0.0
esConfig="/etc/elasticsearch/elasticsearch.yml"
if grep 'network.host: 0' $esConfig ; then
  log "ES configured!"
else
  echo "network.host: 0.0.0.0" >> $esConfig
  service elasticsearch restart
fi

# Make sure ES starts when the VM reboots
sudo update-rc.d elasticsearch defaults 95 10
sudo /etc/init.d/elasticsearch start

apt-get autoremove -y


if grep '^listen_addresses = *' /etc/postgresql/9.4/main/postgresql.conf ; then
  log 'pg already set up'
else
  sed -i -e "s/.*listen_addresses.*$/listen_addresses = '*'/" /etc/postgresql/9.4/main/postgresql.conf
  echo 'host    all             all             0.0.0.0/0              md5' >> /etc/postgresql/9.4/main/pg_hba.conf

  sudo su postgres -c 'psql < /vagrant/script/user.sql'
  service postgresql restart || service postgresql start
fi


# configure rabbit mq
if rabbitmqctl list_users | grep rabbit ; then
  log 'Rabbitmq is ready'
else
  rabbitmqctl add_vhost /main
  rabbitmqctl add_user rabbit p4ssw0rd
  rabbitmqctl set_user_tags rabbit administrator
  rabbitmqctl set_permissions -p /main rabbit "." "." ".*"
  service rabbitmq-server restart
  rabbitmq-plugins enable rabbitmq_management
fi

# setup redis

if grep '^bind 0.0.0.0' /etc/redis/redis.conf ; then
  log 'redis is configured'
else
  sed -i 's/^bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis/redis.conf
  service redis-server restart
fi

# setup rethinkdb
if test -e /etc/rethinkdb/instances.d/main.conf ; then
  log 'rethinkdb already set up'
else
  sed 's/# bind=127.0.0.1/bind=0.0.0.0/g' /etc/rethinkdb/default.conf.sample  > /etc/rethinkdb/instances.d/main.conf
  service rethinkdb restart
fi


service postgresql status || service postgresql start
service elasticsearch status || service elasticsearch start
service redis-server status || service redis-server start
service rethinkdb status || service rethinkdb start

export HOME=/home/root
service rabbitmq-server status || service rabbitmq-server start


log "Storage: done"
