#!/bin/bash

RESOURCE_GROUP="rg-tf-backend-lab"

read -p "Are you sure you want to destroy backend resources? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Operation cancelled"
    exit 1
fi

echo "Checking active resources..."

az resource list --output table

az group delete \
    --name "$RESOURCE_GROUP" \
    --yes \
    --no-wait


echo "Backend destruction initiated"
