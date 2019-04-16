#!/bin/bash

set -euxo pipefail

PWD="$( cd "$( dirname "$0" )" && pwd )"

if [ -d "$PWD/.git" ]; then
  # Running from a clone of the repository

  if hash rpm-ostree 2>/dev/null; then
    # Fedora Silverblue, do not use ansible

    link_dotfile () {
      local file=$1
      local dir=$2

      if [[ -f $HOME/.$file && ! $HOME/.$file -ef $PWD/$dir/$file ]]; then
        mv $HOME/.$file $PWD/$dir/$file
        ln -nP $PWD/$dir/$file $HOME/.$file
      fi
    }
    
    link_dotfile gitconfig roles/git/files
    link_dotfile bash_aliases roles/bashrc/files
    link_dotfile bashrc roles/bashrc/files

  else
    # Install ansible only if not already present
    if ! hash ansible-playbook 2>/dev/null; then

      if [ -f "/etc/fedora-release" ]; then
        sudo dnf -y install ansible python2-dnf
      else
        sudo apt-get install -y software-properties-common
        sudo apt-add-repository -y ppa:ansible/ansible
        sudo apt-get update
        sudo apt-get install -y ansible
      fi

    fi

    # Install ansible galaxy roles
    ansible-galaxy install -r "$PWD/requirements.yml"

    # Run playbook
    ansible-playbook "$PWD/playbook.yaml"

  fi

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

