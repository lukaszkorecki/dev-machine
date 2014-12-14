#!/usr/bin/env bash

set -e

log() {
  logger -s -t PROVISIONER -- "$*"
}

_q() {
  log "> $*"
  $* > /dev/null
}

# get all required packages

_q apt-get update -q
_q apt-get -y -q install git-core  \
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
  tmux


# add brightbox ppa

_q apt-add-repository ppa:brightbox/ruby-ng
_q apt-add-repository ppa:gophers/go
_q apt-add-repository ppa:chris-lea/node.js

# install latest ruby

_q apt-get update -q

_q apt-get -y -q install ruby2.1  ruby2.1-dev nodejs golang

_q update-alternatives --set ruby /usr/bin/ruby2.1

_q gem install bundler pry --no-rdoc --no-ri

# some cleanup
apt-get autoremove -y

# nfs server

if [[ -e /etc/init.d/iptables-persistent ]] ; then
  /etc/init.d/iptables-persistent flush
fi

echo "/home/vagrant *(rw,sync,all_squash,anonuid=1000,insecure,no_subtree_check)" > /etc/exports
exportfs -a
/etc/init.d/nfs-kernel-server restart
