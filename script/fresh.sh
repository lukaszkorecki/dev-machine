#!/usr/bin/env bash

git submodule update --init
vagrant box add hashicorp/precise64
vagrant up
vagrant ssh
