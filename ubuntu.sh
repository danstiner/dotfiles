#!/bin/bash

sudo apt-get install -y ansible

ansible-playbook "${BASH_SOURCE%/*}/playbook.yaml"
