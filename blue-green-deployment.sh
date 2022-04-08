#!/bin/sh

# final task is to replace old with new
## mv www to www_old, www_new to www
## drop old database (name will need to be grepped somehow. probably from wp-config.php of the old one)

export TARGETIP=$(cat reseed-direction/target_ip | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" --progress target-webuser-mysql-creds/creds.cnf deployer@${TARGETIP}:/home/deployer/mysql_creds.cnf
# ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mv ${WEBROOT} ${WEBROOT}_old"
# ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mv ${WEBROOT}_new ${WEBROOT}"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} 'mysql --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 -e "DROP DATABASE $(grep DB_NAME wp-config.php | cut --delimiter=\' -f4);"; rm /home/deployer/mysql_creds.cnf'