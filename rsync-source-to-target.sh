#!/bin/sh

# improve: ssh to target and rsync from there
export SOURCEIP=$(cat reseed-direction/source_ip)
export TARGETIP=$(cat reseed-direction/target_ip)
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" -a --recursive --progress --numeric-ids deployer@${SOURCEIP}:${SITEDIR} ./
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" --rsync-path="sudo rsync" --chown=${WEBUSER}:${WEBUSER} --chmod=D2775,F664 -a --recursive --progress --numeric-ids --delete --exclude=wp-config.php ${SITE} deployer@${TARGETIP}:/var/www/
