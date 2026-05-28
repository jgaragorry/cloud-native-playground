#!/bin/bash

echo "==============================="
echo "RESOURCE INVENTORY"
echo "==============================="

az resource list \
    --query "[].{Name:name,Type:type,Location:location}" \
    --output table

echo ""
echo "==============================="
echo "STORAGE ACCOUNTS"
echo "==============================="

az storage account list \
    --query "[].{Name:name,SKU:sku.name,Location:location}" \
    --output table
