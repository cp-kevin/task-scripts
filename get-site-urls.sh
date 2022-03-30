#!/bin/sh

echo -n ${SITE} > main_site
paste -d'\0' reseed-direction/source_prefix main_site > site-urls/source_site_url
paste -d'\0' reseed-direction/target_prefix main_site > site-urls/target_site_url
sed 's/\./\\\./g' site-urls/source_site_url > site-urls/source_site_url_regex
