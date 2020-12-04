#!/bin/bash

set -e

# install brew
echo "checking brew..."
pip_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  echo "installing brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  if [[ $? != 0 ]]; then
    echo "unable to install brew, script $0 abort!"
    exit 2
  fi
  echo "installed brew"
fi

# install ansible
echo "checking ansible..."
ansible_bin=$(which ansible) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  echo "creating venv"
  echo "installing ansible"
  brew install ansible
  if [[ $? != 0 ]]; then
    echo "unable to install ansible, script $0 abort!"
    exit 2
  fi
  echo "installed ansible"
fi
