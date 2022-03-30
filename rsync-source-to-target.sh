#!/bin/sh

export SOURCEIP=$(cat reseed-direction/source_ip)
export TARGETIP=$(cat reseed-direction/target_ip)
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" -a --recursive --numeric-ids deployer@${SOURCEIP}:${SITEDIR} ./
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" --rsync-path="sudo rsync" --chown=${WEBUSER}:${WEBUSER} --chmod=D2775,F664 -a --recursive --numeric-ids --delete --exclude=wp-config.php ${SITE} deployer@${TARGETIP}:/var/www/
