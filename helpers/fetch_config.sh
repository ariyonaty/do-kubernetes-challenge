#!/bin/bash 

if [[ -z "$DIGITALOCEAN_TOKEN" ]]
then
    echo "[-] DigitalOcean token is not set to DIGITALOCEAN_TOKEN."
    exit 1
fi

if [[ $1 -eq 0 ]]
then
    echo "[-] Usage: ./fetch_config.sh <CLUSTER_ID>"
    echo "    CLUSTER_ID was not provided."
    exit 2
fi

DO_TOKEN=$DIGITALOCEAN_TOKEN
CLUSTER_ID=$1

curl -X GET -v -O \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DO_TOKEN" \
    "https://api.digitalocean.com/v2/kubernetes/clusters/$CLUSTER_ID/kubeconfig"

