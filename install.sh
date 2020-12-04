#!/bin/bash

set -e

VAR_FILE=ansible-osx/host_vars/localhost

# check if template vars need to be filled out
for VAR in "{HOSTNAME}" "{USER_FULLNAME}" "{USER_EMAIL}"
do
  var_check=$(grep $VAR $VAR_FILE) 2>&1 > /dev/null && returncode=$? || returncode=$?
  if [[ $returncode -eq 0 ]]; then
    echo "Please enter the desired value for $VAR..."
    read VALUE
    sed -i '' -e "s/$VAR/$VALUE/g" $VAR_FILE
  fi
done

# install ansible
echo "checking ansible..."
ansible_bin=$(which ansible) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  PATH=./venv/bin:$PATH
  ansible_bin=$(which ansible) 2>&1 > /dev/null
  if [[ $? != 0 ]]; then
    echo "creating venv"
    python3 -m venv venv
    source venv/bin/activate
    echo "installing ansible"
    CPPFLAGS=-I/usr/local/opt/openssl/include
    LDFLAGS=-L/usr/local/opt/openssl/lib
    pip install ansible
    if [[ $? != 0 ]]; then
      echo "unable to install ansible, script $0 abort!"
      echo "If you are having trouble installing ansible, try running ./fallback_prereqs.sh first as an alternative."
      exit 2
    fi
    echo "leaving venv"
    deactivate
    echo "installed ansible"
  fi
fi

echo "Please enter your sudo password"
read -s PASSWORD

cd ansible-osx
ansible-galaxy install -r requirements.yml
ansible-playbook playbook.yml --extra-vars="ansible_become_pass=$PASSWORD"

