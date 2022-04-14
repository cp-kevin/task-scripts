#!/bin/sh

# echo -n ${SITES} > main_site
# paste -d'\0' reseed-direction/source_prefix main_site > site-urls/source_site_url
# paste -d'\0' reseed-direction/target_prefix main_site > site-urls/target_site_url
# sed 's/\./\\\./g' site-urls/source_site_url > site-urls/source_site_url_regex

export SOURCE_PREFIX=$(cat reseed-direction/source_prefix)
export TARGET_PREFIX=$(cat reseed-direction/target_prefix)

for SITE in $(echo ${SITES} | sed "s/,/ /g"); do
    echo ${SITE} >> site-urls/site_urls
done
