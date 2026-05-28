#!/bin/bash

set -e

cd terraform

terraform fmt -recursive
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
