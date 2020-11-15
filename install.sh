#!/bin/bash

# install pip
echo "checking pip..."
pip_bin=$(which pip) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  echo "installing pip"
  sudo easy_install pip
  if [[ $? != 0 ]]; then
    echo "unable to install pip, script $0 abort!"
    exit 2
  fi
  echo "installed pip"
fi

# install virtualenv
echo "checking virtualenv..."
pip_bin=$(which virtualenv) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  echo "installing virtualenv"
  sudo pip install virtualenv
  if [[ $? != 0 ]]; then
    echo "unable to install virtualenv, script $0 abort!"
    exit 2
  fi
  echo "installed virtualenv"
fi

PATH=./venv/bin:$PATH

# install ansible
echo "checking ansible..."
ansible_bin=$(which ansible) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  echo "creating venv"
  virtualenv venv
  echo "entering venv"
  source venv/bin/activate
  echo "installing ansible"
  pip install ansible
  if [[ $? != 0 ]]; then
    echo "unable to install ansible, script $0 abort!"
    exit 2
  fi
  echo "installed ansible"
  echo "leaving venv"
  deactivate
fi

echo "Please enter your sudo password"
read -s PASSWORD

cd ansible-osx
~/Library/Python/2.7/bin/ansible-galaxy install -r requirements.yml
~/Library/Python/2.7/bin/ansible-playbook playbook.yml --extra-vars='ansible_become_pass=$PASSWORD'

cp ./dotfiles/.[^.]* ~/
