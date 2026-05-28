#!/bin/bash

RESOURCE_GROUP="rg-cloud-native-week2"

az resource list \
    --resource-group "$RESOURCE_GROUP" \
    --output table
