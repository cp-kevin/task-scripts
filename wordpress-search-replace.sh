#!/bin/sh

# export TARGETIP=$(cat reseed-direction/target_ip | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
# export SOURCEURL=$(cat site-urls/source_site_url)
# export TARGETURL=$(cat site-urls/target_site_url)
# export SOURCEURLREGEX=$(cat site-urls/source_site_url_regex)
# export TARGETAADSSO=$(cat reseed-direction/target_aadsso | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
# ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${SOURCEURL} search-replace --regex '^${SOURCEURLREGEX}$' ${TARGETURL}"
# ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} search-replace https://${SOURCEURL} https://${TARGETURL}"
# ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} search-replace http://${SOURCEURL} http://${TARGETURL}"
# ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} elementor replace_urls https://${SOURCEURL} https://${TARGETURL}"
# ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} elementor replace_urls http://${SOURCEURL} http://${TARGETURL}"
# ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} --skip-themes --skip-plugins option delete aadsso_settings"
# ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "echo ${TARGETAADSSO} | base64 -d > target-aadsso"
# ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} --skip-themes --skip-plugins option add aadsso_settings < target-aadsso; rm target-aadsso"

set +x

export TARGETIP=$(cat reseed-direction/target_ip | openssl enc -d -aes-256-ctr -pbkdf2 -a -base64 -pass pass:${ENCRYPTPASS})
export SOURCEPREFIX=$(cat reseed-direction/source_prefix)
export TARGETPREFIX=$(cat reseed-direction/target_prefix)
while read -r SITE; do
    if [ -s reseed-direction/source_prefix ]; then
        export SOURCEURL=${SOURCEPREFIX}.${SITE}
    else
        export SOURCEURL=${SITE}
    fi
    if [ -s reseed-direction/target_prefix ]; then
        export TARGETURL=${TARGETPREFIX}.${SITE}
    else
        export TARGETURL=${SITE}
    fi
    export SOURCEURLREGEX=$(echo ${SOURCEURL} | sed 's/\./\\\./g')

    ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${SITE} search-replace --regex '^${SOURCEURLREGEX}$' ${TARGETURL}"
    ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} search-replace https://${SOURCEURL} https://${TARGETURL}"
    ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} search-replace http://${SOURCEURL} http://${TARGETURL}"
    ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} elementor replace_urls https://${SOURCEURL} https://${TARGETURL} || true"
    ssh -o StrictHostKeyChecking=no -i deployer-ssh-key/deployer deployer@${TARGETIP} "wp --path=${WEBROOT}_new --url=${TARGETURL} elementor replace_urls http://${SOURCEURL} http://${TARGETURL} || true"
done < site-urls/site_urls
