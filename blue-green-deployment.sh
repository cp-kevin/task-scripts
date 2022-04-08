#!/bin/sh

# final task is to replace old with new
## mv www to www_old, www_new to www
## drop old database (name will need to be grepped somehow. probably from wp-config.php of the old one)

export TARGETIP=$(cat reseed-direction/target_ip | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mv ${WEBROOT} ${WEBROOT}_old"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mv ${WEBROOT}_new ${WEBROOT}"
