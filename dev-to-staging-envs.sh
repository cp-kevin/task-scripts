#!/bin/sh

echo dev. > reseed-direction/source_prefix
echo staging. > reseed-direction/target_prefix
echo ${MYSQLUSER} | openssl enc -e -aes-256-ctr -pbkdf2 -a -base64 -salt -pass pass:${ENCRYPTPASS} > reseed-direction/source_mysql_user
echo ${MYSQLUSER} | openssl enc -e -aes-256-ctr -pbkdf2 -a -base64 -salt -pass pass:${ENCRYPTPASS} > reseed-direction/target_mysql_user
echo ${SOURCEMYSQLPASS} | openssl enc -e -aes-256-ctr -pbkdf2 -a -base64 -salt -pass pass:${ENCRYPTPASS} > reseed-direction/source_mysql_pass
echo ${TARGETMYSQLPASS} | openssl enc -e -aes-256-ctr -pbkdf2 -a -base64 -salt -pass pass:${ENCRYPTPASS} > reseed-direction/target_mysql_pass
echo ${SOURCEIP} | openssl enc -e -aes-256-ctr -pbkdf2 -a -base64 -salt -pass pass:${ENCRYPTPASS} > reseed-direction/source_ip
echo ${TARGETIP} | openssl enc -e -aes-256-ctr -pbkdf2 -a -base64 -salt -pass pass:${ENCRYPTPASS} > reseed-direction/target_ip
echo ${TARGETAADSSO} | openssl enc -e -aes-256-ctr -pbkdf2 -a -base64 -salt -pass pass:${ENCRYPTPASS} > reseed-direction/target_aadsso