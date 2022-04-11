#!/bin/sh

export TARGETIP=$(cat reseed-direction/target_ip | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
export OLDDBNAME=$(cat www-old-info/old_db_name)
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" deployer@${TARGETIP}:${WEBROOT}/wp-config.php ./
grep DB_NAME wp-config.php | cut -d \' -f4 > target_db_name
export TARGETOLDDBNAME=$(cat target_db_name)

rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" --progress target-webuser-mysql-creds/creds.cnf deployer@${TARGETIP}:/home/deployer/mysql_creds.cnf
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mv ${WEBROOT} ${WEBROOT}_old"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mv ${WEBROOT}_new ${WEBROOT}"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mysql --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 -e 'DROP DATABASE ${TARGETOLDDBNAME};'; rm /home/deployer/mysql_creds.cnf"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "rm -r ${WEBROOT}_old"
