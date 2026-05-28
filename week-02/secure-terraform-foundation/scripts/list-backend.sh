#!/bin/bash

RESOURCE_GROUP="rg-tf-backend-lab"

az storage account list \
    --resource-group "$RESOURCE_GROUP" \
    --output table
