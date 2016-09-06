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

echo "Etc/UTC" > /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata


set -e

# get all required packages

_q apt-get update -q
_q apt-get -y -q install  \
  ntp \
  libffi6 \
  libffi-dev \
  python-software-properties \
  build-essential \
  libpq-dev \
  unzip \
  libsqlite3-dev \
  poppler-utils \
  libcurl4-openssl-dev \
  libsqlite3-dev \
  nfs-server \
  python2.7 \
  python2.7-dev \
  python-pip \
  tmux \
  htop \
  tree \
  nginx \
  libmysqlclient-dev  \
  libevent-dev  \
  libxml2-dev  \
  libxslt1-dev  \
  libreadline-dev


pip install ansible

# add openjdk ppa

yes | apt-add-repository ppa:openjdk-r/ppa

# add latest git

yes | apt-add-repository ppa:git-core/ppa

# add racket ppa

yes | apt-add-repository  ppa:plt/racket


# add brightbox ppa

yes | apt-add-repository ppa:brightbox/ruby-ng


# add latest-ish node
curl -q https://deb.nodesource.com/gpgkey/nodesource.gpg.key > /tmp/nodekey
apt-key add /tmp/nodekey
add-apt-repository 'deb https://deb.nodesource.com/node_4.x trusty main'

# install latest everthing

_q apt-get update -q

apt-get -y -q install git racket ruby2.2  ruby2.2-dev nodejs openjdk-8-jdk openjdk-8-jre

_q update-alternatives --set ruby /usr/bin/ruby2.2

_q gem install bundler pry rake m rubocop dotenv --no-rdoc --no-ri

# some cleanup
apt-get autoremove -y

# nfs server

if [[ -e /etc/init.d/iptables-persistent ]] ; then
  /etc/init.d/iptables-persistent flush
fi

if [[ -e /vagrant ]] ;then
  export NFS_ROOT=/home/vagrant
else
  export NFS_ROOT=/home/ubuntu
fi

echo "$NFS_ROOT *(rw,sync,all_squash,anonuid=1000,insecure,no_subtree_check)" > /etc/exports
exportfs -a
/etc/init.d/nfs-kernel-server restart


# install docker

if grep docker /etc/apt/sources.list ; then
  echo 'docker installed'
else
  curl https://apt.dockerproject.org/gpg > /tmp/docker-key

  apt-key add /tmp/docker-key

  add-apt-repository 'deb https://apt.dockerproject.org/repo ubuntu-trusty main'
  apt-get update
  apt-get install -y docker-engine
fi
