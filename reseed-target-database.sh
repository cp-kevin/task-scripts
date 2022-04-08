#!/bin/sh

export TARGETIP=$(cat reseed-direction/target_ip  | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
export YYYMMDDHHMM=$(date +"%Y%m%d%H%M")
rsync -e "ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer" --progress target-webuser-mysql-creds/creds.cnf deployer@${TARGETIP}:/home/deployer/mysql_creds.cnf
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mysql --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 -e 'CREATE DATABASE ${DBNAME}_${YYYMMDDHHMM}'"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "mysql --defaults-extra-file=/home/deployer/mysql_creds.cnf -h 127.0.0.1 -P 6033 ${DBNAME}_${YYYMMDDHHMM} < ${SITEDIR}/prod_tmp_db_dump.sql; rm /home/deployer/mysql_creds.cnf"
# sed wp-config.php and replace database name
# next step, allow wordpress search-replace to happen
# final task is to replace old with new
## mv www to www_old, www_new to www
## drop old database (name will need to be grepped somehow. probably from wp-config.php of the old one)