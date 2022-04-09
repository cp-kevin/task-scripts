#!/bin/sh

export TARGETIP=$(cat reseed-direction/target_ip  | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
export YYYYMMDDHHmm=$(date +"%Y%m%d%H%M")
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" --progress target-webuser-mysql-creds/creds.cnf deployer@${TARGETIP}:/home/deployer/mysql_creds.cnf
# User has wildcard grant
# GRANT ALL PRIVILEGES ON `redacted%`.* TO redacted@'127.0.0.1';
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mysql --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 -e 'CREATE DATABASE ${DBNAME}_${YYYYMMDDHHmm}'"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mysql --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 ${DBNAME}_${YYYYMMDDHHmm} < ${SITEDIR}/tmp_db_dump.sql; rm /home/deployer/mysql_creds.cnf"
# can either rsync including wp-config.php and sed it after, or just copy the old web root wp-config (this seds old file to a new file)
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "sed 's/.*DB_NAME.*/define(\x27DB_NAME\x27, \x27${DBNAME}_${YYYYMMDDHHmm}\x27);/' ${WEBROOT}/wp-config.php > ${WEBROOT}_new/wp-config.php"
