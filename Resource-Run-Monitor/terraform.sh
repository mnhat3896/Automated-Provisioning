#!/bin/bash

# NOTE: PASS YOUR AGRUMENT HERE
RESOURCE_GROUP_NAME=""
STORAGE_ACCOUNT_NAME=""
STORAGE_ACCOUNT_CONTAINER_NAME=""
SUBSCRIPTION=""
LOCATION=""
TF_KEY_NAME="" # ex: prod.terraform.tfstate
################################

# if [[ $(az storage account check-name --name $STORAGE_ACCOUNT_NAME --query "reason") != *"AlreadyExists"* ]]; then

#   az group create --location $LOCATION --name $RESOURCE_GROUP_NAME
#   az storage account create \
      # --name $STORAGE_ACCOUNT_NAME \
      # --resource-group $RESOURCE_GROUP_NAME \
      # --kind StorageV2 \
      # --sku Standard_ZRS \
      # --https-only true \
      # --allow-blob-public-access false \
      # --access-tier Hot \
      # --subscription $SUBSCRIPTION \
      # --location $LOCATION

#   az storage container create --name $STORAGE_ACCOUNT_CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
#   sa_key="$(az storage account keys list -g $RESOURCE_GROUP_NAME -n $STORAGE_ACCOUNT_NAME --query "[0].value")"
#   echo "storage_account_name=\"$STORAGE_ACCOUNT_NAME\"" >> ./Terraform/tfbackend.conf
#   echo "container_name=\"$STORAGE_ACCOUNT_CONTAINER_NAME\"" >> ./Terraform/tfbackend.conf
#   echo "key=\"$TF_KEY_NAME\"" >> ./Terraform/tfbackend.conf
#   echo "access_key=$sa_key" >> ./Terraform/tfbackend.conf
# fi
# >&2 echo "The storage account named $STORAGE_ACCOUNT_NAME is already taken.!!!"
# exit 1

az group create --location $LOCATION --name $RESOURCE_GROUP_NAME
az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --kind StorageV2 \
  --sku Standard_ZRS \
  --https-only true \
  --allow-blob-public-access false \
  --access-tier Hot \
  --subscription $SUBSCRIPTION \
  --location $LOCATION

az storage container create -n $STORAGE_ACCOUNT_CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --public-access off

sa_key="$(az storage account keys list -g $RESOURCE_GROUP_NAME -n $STORAGE_ACCOUNT_NAME --query "[0].value")"

# If cannot get sa key ==> exit (avoid create tfbackend.conf file)
[[ -z "$sa_key" ]] && echo "Cannot get storage account access key" && exit 1

echo '' > ./Terraform/tfbackend.conf
echo "storage_account_name=\"$STORAGE_ACCOUNT_NAME\"" >> ./Terraform/tfbackend.conf
echo "container_name=\"$STORAGE_ACCOUNT_CONTAINER_NAME\"" >> ./Terraform/tfbackend.conf
echo "key=\"$TF_KEY_NAME\"" >> ./Terraform/tfbackend.conf
echo "access_key=$sa_key" >> ./Terraform/tfbackend.conf


if [ -f ./Terraform/tfbackend.conf ]; then
  cd Terraform

  terraform init -backend-config=tfbackend.conf

  terraform plan -out plan

  terraform apply -auto-approve -input=false plan

  rm tfbackend.conf

  echo "provisioning success <3"
fi
