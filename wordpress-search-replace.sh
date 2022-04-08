#!/bin/sh
set -x

export TARGETIP=$(cat reseed-direction/target_ip | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
export SOURCEURL=$(cat site-urls/source_site_url)
export TARGETURL=$(cat site-urls/target_site_url)
export SOURCEURLREGEX=$(cat site-urls/source_site_url_regex)
export TARGETAADSSO=$(cat reseed-direction/target_aadsso | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${SOURCEURL} search-replace --regex '^${SOURCEURLREGEX}$' ${TARGETURL}"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} search-replace https://${SOURCEURL} https://${TARGETURL}"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} search-replace http://${SOURCEURL} http://${TARGETURL}"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} --skip-themes --skip-plugins option delete aadsso_settings"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "echo ${TARGETAADSSO} | base64 -d > target-aadsso"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} --skip-themes --skip-plugins option add aadsso_settings < target-aadsso; rm target-aadsso"

# next step, allow wordpress search-replace to happen
# final task is to replace old with new
## mv www to www_old, www_new to www
## drop old database (name will need to be grepped somehow. probably from wp-config.php of the old one)