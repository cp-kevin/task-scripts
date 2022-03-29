#!/bin/sh

echo ((ssh.deployer)) | base64 -d > deployer-ssh-key/deployer
chmod 600 deployer-ssh-key/deployer