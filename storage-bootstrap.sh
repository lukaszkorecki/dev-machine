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

if grep rabbitmq /etc/apt/sources.list ; then
  echo 'Rabbit installed'
else
  curl https://www.rabbitmq.com/rabbitmq-signing-key-public.asc > /tmp/rabbit-key
  apt-key add /tmp/rabbit-key

  add-apt-repository 'deb http://www.rabbitmq.com/debian/ testing main'
  apt-get update
fi

if grep postgresql  /etc/apt/sources.list ; then
  echo 'PG installed'
else
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc > /tmp/pg-key
  apt-key add /tmp/pg-key

  add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main"
  apt-get update
fi

apt-get install -y -q  \
  htop \
  postgresql-9.4 \
  redis-server \
  redis-tools \
  openjdk-7-jre-headless \
  elasticsearch \
  rabbitmq-server \
  postgresql-contrib-9.4

if test -e /usr/share/elasticsearch/plugins/kopf ; then
  echo 'kopf already installed'
else

  cd /usr/share/
  ./elasticsearch/bin/plugin --install lmenezes/elasticsearch-kopf/
fi

apt-get remove ufw -y
apt-get autoremove -y


if grep '^listen_addresses = *' /etc/postgresql/9.4/main/postgresql.conf ; then
  echo 'pg already set up'
else
  sed -i -e "s/.*listen_addresses.*$/listen_addresses = '*'/" /etc/postgresql/9.4/main/postgresql.conf
  echo 'host    all             all             0.0.0.0/0              md5' >> /etc/postgresql/9.4/main/pg_hba.conf

  sudo su postgres -c 'psql < /vagrant/script/user.sql'
  service postgresql restart || service postgresql start
fi


# configure rabbit mq
if rabbitmqctl list_users | grep rabbit ; then
  echo 'Rabbitmq is ready'
else
  rabbitmqctl add_vhost /main
  rabbitmqctl add_user rabbit p4ssw0rd
  rabbitmqctl set_user_tags rabbit administrator
  rabbitmqctl set_permissions -p /main rabbit "." "." ".*"
  service rabbitmq-server restart
  rabbitmq-plugins enable rabbitmq_management
fi

service postgresql status || service postgresql start
service elasticsearch status || service elasticsearch start
service redis-server status || service redis-server start
service rabbitmq-server status || service rabbitmq-server start
