#!/bin/bash

sudo dnf -y install ansible python2-dnf || exit 1

ansible-playbook "${BASH_SOURCE%/*}/playbook.yaml" || exit 1
