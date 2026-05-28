#!/bin/bash

echo "Checking public access..."

az storage account list \
    --query "[].{Name:name,PublicAccess:allowBlobPublicAccess}" \
    --output table

echo "Checking TLS version..."

az storage account list \
    --query "[].{Name:name,TLS:minimumTlsVersion}" \
    --output table

echo "Checking Key Vault public access..."

az keyvault list \
    --query "[].{Name:name,PublicAccess:properties.publicNetworkAccess}" \
    --output table
