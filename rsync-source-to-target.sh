#!/bin/sh

# improve: ssh to target and rsync from there
export SOURCEIP=$(cat reseed-direction/source_ip | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
export TARGETIP=$(cat reseed-direction/target_ip | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${SOURCEIP} "rsync -e 'ssh -o StrictHostKeyChecking=no -i .ssh/deployer' --rsync-path='sudo rsync' --chown=${WEBUSER}:${WEBUSER} --chmod=D2775,F664 -a --progress --numeric-ids --delete ${SITEDIR}/*.sql deployer@${TARGETIP}:${SITEDIR}/"
# exclude wp-config because it will be seeded in next 
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${SOURCEIP} "rsync -e 'ssh -o StrictHostKeyChecking=no -i .ssh/deployer' --rsync-path='sudo rsync' --chown=${WEBUSER}:${WEBUSER} --chmod=D2775,F664 -a --recursive --progress --numeric-ids --delete --exclude=wp-config.php ${WEBROOT}/ deployer@${TARGETIP}:${WEBROOT}_new/"