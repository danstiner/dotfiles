#!/bin/bash

set -euxo pipefail

if [ -d "${BASH_SOURCE%/*}/.git" ]; then
  # Running from a clone of the repository

  # Install ansible only if not already present
  if ! hash ansible-playbook 2>/dev/null; then
    if [ -f "/etc/fedora-release" ]; then
      sudo dnf -y install ansible python2-dnf
    else
      sudo apt-get update
      sudo apt-get install -y ansible
    fi
  fi

  # Install ansible galaxy roles
  ansible-galaxy install -r "${BASH_SOURCE%/*}/requirements.yml"

  # Run playbook
  ansible-playbook "${BASH_SOURCE%/*}/playbook.yaml" 

else
  # Running from outside repository, first make a clone

  # Install git
  if [ -f "/etc/fedora-release" ]; then
    sudo dnf install git
  else
    sudo apt install git
  fi

  # Clone the repository
  if [ ! -f "$HOME/dotfiles/install.sh" ]; then
    git clone https://github.com/danstiner/dotfiles.git "$HOME/dotfiles"
  fi

  # Run installer from clone
  "$HOME/dotfiles/install.sh"

fi
