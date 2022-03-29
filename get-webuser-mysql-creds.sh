#!/bin/sh

cat > prod-webuser-mysql-creds/creds.cnf <<EOF
[client]
user=${MYSQLUSER}
pass=${MYSQLPASS}
EOF

cat prod-webuser-mysql-creds/creds.cnf
