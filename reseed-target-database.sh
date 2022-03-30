#!/bin/sh

export TARGETIP=$(cat reseed-direction/target_ip)
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" --progress target-webuser-mysql-creds/creds.cnf deployer@${TARGETIP}:/home/deployer/mysql_creds.cnf
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mysql --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 -e 'DROP DATABASE ${DBNAME}'"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mysql --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 -e 'CREATE DATABASE ${DBNAME}'"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mysql --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 ${DBNAME} < ${SITEDIR}/prod_tmp_db_dump.sql; rm /home/deployer/mysql_creds.cnf"
