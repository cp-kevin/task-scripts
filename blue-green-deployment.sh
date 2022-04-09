#!/bin/sh

export TARGETIP=$(cat reseed-direction/target_ip | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" --progress target-webuser-mysql-creds/creds.cnf deployer@${TARGETIP}:/home/deployer/mysql_creds.cnf
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mv ${WEBROOT} ${WEBROOT}_old"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mv ${WEBROOT}_new ${WEBROOT}"
# Store variable in file because of the delimiter causing issues with the next command
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "grep DB_NAME ${WEBROOT}_old/wp-config.php | cut -d \' -f4 > OLDDBNAME"
# Use of single quotes here is intentional to allow the use of the target's variables
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} 'export OLDDBNAME=$(cat OLDDBNAME); mysql --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 -e "DROP DATABASE ${OLDDBNAME};"; rm /home/deployer/OLDDBNAME; rm /home/deployer/mysql_creds.cnf'
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "rm -r ${WEBROOT}_old"
