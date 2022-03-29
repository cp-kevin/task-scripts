#!/bin/sh

cat > prod-webuser-mysql-creds/creds.cnf <<EOF
[client]
user=${MYSQLUSER}
password=${MYSQLPASS}
EOF
