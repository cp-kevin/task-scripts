#!/bin/sh

export MYSQLUSER=$(cat reseed-direction/target_mysql_user)
export MYSQLPASS=$(cat reseed-direction/target_mysql_pass)
cat > target-webuser-mysql-creds/creds.cnf <<EOF
[client]
user=${MYSQLUSER}
password=${MYSQLPASS}
EOF
