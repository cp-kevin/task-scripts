#!/bin/sh

export TARGETIP=$(cat reseed-direction/target_ip)
export SOURCEURL=$(cat site-urls/source_site_url)
export TARGETURL=$(cat site-urls/target_site_url)
export SOURCEURLREGEX=$(cat site-urls/source_site_url_regex)
export TARGETAADSSO=$(cat reseed-direction/target_aadsso)
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT} --url=${SOURCEURL} search-replace --regex '^${SOURCEURLREGEX}$' ${TARGETURL}"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT} --url=${TARGETURL} search-replace https://${SOURCEURL} https://${TARGETURL}"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT} --url=${TARGETURL} search-replace http://${SOURCEURL} http://${TARGETURL}"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT} --url=${TARGETURL} --skip-themes --skip-plugins option delete aadsso_settings"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "echo ((online_torontofilmschool_ca.STAGE-AADSSO)) | base64 -d > stage-aadsso"
ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT} --url=${TARGETURL} --skip-themes --skip-plugins option add aadsso_settings < stage-aadsso; rm stage-aadsso"