#!/bin/sh

export MYSQLUSER=$(cat reseed-direction/source_mysql_user | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
export MYSQLPASS=$(cat reseed-direction/source_mysql_pass | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
cat > source-webuser-mysql-creds/creds.cnf <<EOF
[client]
user=${MYSQLUSER}
password=${MYSQLPASS}
EOF
