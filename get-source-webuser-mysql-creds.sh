#!/bin/sh

export MYSQLUSER=$(cat reseed-direction/source_mysql_user)
export MYSQLPASS=$(cat reseed-direction/source_mysql_pass)
cat > source-webuser-mysql-creds/creds.cnf <<EOF
[client]
user=${MYSQLUSER}
password=${MYSQLPASS}
EOF
