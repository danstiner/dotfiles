#!/bin/bash

sudo apt-get install -y software-properties-common || exit 1
sudo apt-add-repository -y ppa:ansible/ansible || exit 1
sudo apt-get update || exit 1
sudo apt-get install -y ansible || exit 1

ansible-playbook "${BASH_SOURCE%/*}/playbook.yaml" || exit 1
