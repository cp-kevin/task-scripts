#!/bin/sh

echo staging. > reseed-direction/source_prefix
echo dev. > reseed-direction/target_prefix
echo ${MYSQLUSER} > reseed-direction/source_mysql_user
echo ${SOURCEMYSQLPASS} > reseed-direction/source_mysql_pass
echo ${TARGETMYSQLPASS} > reseed-direction/target_mysql_pass
