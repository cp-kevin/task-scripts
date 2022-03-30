#!/bin/sh

touch reseed-direction/source_prefix
echo staging. > reseed-direction/target_prefix
echo ${MYSQLUSER} > reseed-direction/source_mysql_user
echo ${MYSQLUSER} > reseed-direction/target_mysql_user
echo ${SOURCEMYSQLPASS} > reseed-direction/source_mysql_pass
echo ${TARGETMYSQLPASS} > reseed-direction/target_mysql_pass
echo ${SOURCEIP} > reseed-direction/source_ip
echo ${TARGETIP} > reseed-direction/target_ip