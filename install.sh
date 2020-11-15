#!/bin/bash

# install pip
echo "checking pip..."
pip_bin=$(which pip) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  echo "installing pip"
  sudo easy_install pip
  if [[ $? != 0 ]]; then
    error "unable to install pip, script $0 abort!"
    exit 2
  fi
  echo "installed pip"
fi

PATH=~/Library/Python/2.7/bin:$PATH

# install ansible
echo "checking ansible..."
ansible_bin=$(which ansible) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  echo "installing ansible"
  pip install ansible
  if [[ $? != 0 ]]; then
    echo "unable to install ansible, script $0 abort!"
    exit 2
  fi
  echo "installed ansible"
fi

cd ansible-osx
~/Library/Python/2.7/bin/ansible-galaxy install -r requirements.yml
~/Library/Python/2.7/bin/ansible-playbook playbook.yml --ask-become-pass

cp ./dotfiles/.[^.]* ~/
