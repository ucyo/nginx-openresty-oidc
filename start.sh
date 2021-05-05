#!/usr/bin/env bash

set -o errexit
set -o pipefail
#set -o nounset
#set -o xtrace

envsubst < /nginx/conf/nginx.conf.template > /nginx/conf/nginx.conf

nginx -p /nginx -g "daemon off;"
