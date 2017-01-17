#!/bin/bash

if [ -d "${BASH_SOURCE%/*}/.git" ]; then
  # Running from a clone of the repository

  # Install ansible only if not already present
  if ! hash ansible-playbook 2>/dev/null; then
    if [ -f "/etc/fedora-release" ]; then
      sudo dnf -y install ansible python2-dnf || exit 1
    else
      sudo apt-get install -y software-properties-common || exit 1
      sudo apt-add-repository -y ppa:ansible/ansible || exit 1
      sudo apt-get update || exit 1
      sudo apt-get install -y ansible || exit 1
    fi
  fi

  # Run playbook
  ansible-playbook "${BASH_SOURCE%/*}/playbook.yaml" || exit 1

else
  # Running from outside repository, first make a clone

  # Install git
  if [ -f "/etc/fedora-release" ]; then
    sudo dnf install git || exit 1
  else
    sudo apt install git || exit 1
  fi

  # Clone the repository
  if [ -f "$HOME/dotfiles/install.sh" ]; then
    git clone https://github.com/danstiner/dotfiles.git "$HOME/dotfiles" || exit 1
  fi

  # Run installer from clone
  "$HOME/dotfiles/install.sh" || exit 1

fi

