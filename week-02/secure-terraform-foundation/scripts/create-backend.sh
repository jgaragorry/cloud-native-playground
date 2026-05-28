#!/bin/bash

set -e

LOCATION="eastus"
RESOURCE_GROUP="rg-tf-backend-lab"
STORAGE_ACCOUNT="tfbackendcnplayground"
CONTAINER_NAME="tfstate"

TAGS="environment=lab project=cloud-native-playground owner=jgaragorry managed-by=terraform cost-center=education"

echo "Checking Resource Group..."

RG_EXISTS=$(az group exists --name "$RESOURCE_GROUP")

if [ "$RG_EXISTS" = "true" ]; then
    echo "Resource Group already exists"
else
    echo "Creating Resource Group..."

    az group create \
	--output none \
        --name "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --tags $TAGS
fi

EXISTS=$(az storage account check-name --name "$STORAGE_ACCOUNT" --query nameAvailable -o tsv)

if [ "$EXISTS" = "true" ]; then

    az storage account create \
	--output none \
        --name "$STORAGE_ACCOUNT" \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --sku Standard_LRS \
        --kind StorageV2 \
        --https-only true \
        --min-tls-version TLS1_2 \
        --allow-blob-public-access false \
        --tags $TAGS

else
    echo "Storage Account already exists"
fi

ACCOUNT_KEY=$(az storage account keys list \
    --resource-group "$RESOURCE_GROUP" \
    --account-name "$STORAGE_ACCOUNT" \
    --query '[0].value' -o tsv)

az storage container create \
    --output none \
    --name "$CONTAINER_NAME" \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$ACCOUNT_KEY"

az storage account blob-service-properties update \
    --output none \
    --account-name "$STORAGE_ACCOUNT" \
    --resource-group "$RESOURCE_GROUP" \
    --enable-versioning true

az storage blob service-properties delete-policy update \
    --output none \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$ACCOUNT_KEY" \
    --enable true \
    --days-retained 7

echo "========================================="
echo "REMOTE BACKEND CREATED"
echo "========================================="
echo "RESOURCE_GROUP=$RESOURCE_GROUP"
echo "STORAGE_ACCOUNT=$STORAGE_ACCOUNT"
echo "CONTAINER_NAME=$CONTAINER_NAME"
