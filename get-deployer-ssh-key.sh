#!/bin/sh

echo ${DEPLOYER} | base64 -d > deployer-ssh-key/deployer
chmod 600 deployer-ssh-key/deployer