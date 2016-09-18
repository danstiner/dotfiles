#!/bin/bash

sudo apt install -y ansible

ansible-playbook "${BASH_SOURCE%/*}/playbook.yaml"
