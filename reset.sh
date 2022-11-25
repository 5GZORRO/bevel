#!/bin/bash
##############################################################################################
#  Copyright Accenture. All Rights Reserved.
#
#  SPDX-License-Identifier: Apache-2.0
##############################################################################################

set -e

echo "Extract git url from network.yaml"
giturl=$(yq -r .network.organizations[0].gitops.git_url build/network.yaml)

echo "Cloning git repo"
git -C bevel/ init
git -C bevel/ remote add origin $giturl 
git -C bevel/ fetch
git -C bevel/ checkout develop

echo "Copy build artifacts from volume file"
cp -r build bevel

echo "Starting build process..."

echo "Adding env variables..."
export PATH=/root/bin:$PATH

#Path to k8s config file
KUBECONFIG=/home/bevel/build/config


echo "Running the playbook..."
exec ansible-playbook -vv /home/bevel/platforms/shared/configuration/site.yaml --inventory-file=/home/bevel/platforms/shared/inventory/ -e "@/home/bevel/build/network.yaml" -e 'ansible_python_interpreter=/usr/bin/python3' -e "reset='true'"
