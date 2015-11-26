#!/bin/bash

git clone --recursive git://github.com/ansible/ansible.git temp-build-ansible
cd temp-build-ansible
make rpm
sudo rpm -Uvh rpm-build/ansible-*.noarch.rpm
cd ..
rm -rf temp-build-ansible
