#!/bin/sh

export SOURCEIP=$(cat reseed-direction/source_ip  | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" source-webuser-mysql-creds/creds.cnf deployer@${SOURCEIP}:/home/deployer/mysql_creds.cnf
# compress would be improvement
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${SOURCEIP} "mysqldump --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 --single-transaction --no-create-db ${DBNAME} > ${SITEDIR}/prod_tmp_db_dump.sql; rm /home/deployer/mysql_creds.cnf"
