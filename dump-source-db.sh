#!/bin/sh

export SOURCEIP=$(cat reseed-direction/source_ip)
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" source-webuser-mysql-creds/creds.cnf deployer@${SOURCEIP}:/home/deployer/mysql_creds.cnf
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${SOURCEIP} "mysqldump --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 --single-transaction ${DBNAME} > ${SITEDIR}/prod_tmp_db_dump.sql; rm /home/deployer/mysql_creds.cnf"
