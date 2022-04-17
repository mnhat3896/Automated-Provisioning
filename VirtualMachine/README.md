## CLOUD: AZURE
### Create remote state storage account
https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli

### Authentication

```
az login
```
```
az account set --subscription <name or id>
```

### Each Env is a subscription or using one subscription and each Env is a resource group?
It up to you.

- For deploy on multi subscription, need to have one `share subscription` which one will store terraform state. Another subscription is an environment. Which this way we can avoid unexpected situations or at least let terraform state in production environment

    Example:
    ```
    subscription-share
    subscription-dev
    subscription-uat
    ```

- And which one subscription, we use resource group as Env. Not recommend this way, can be deleting or editing by mistake, not easier to grant permissions, Can't maximum limit devs access to production resources


### Create workspace

1. Init terraform
    > NOTE: <mark>Don't use this</mark>
    ```
    terraform init -backend-config access_key="<storage_access key>"
    ```
    <mark>Using environment variable instead</mark>
    ```
    export ARM_ACCESS_KEY=XXXX
    ```
    Why? Reference: https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli#3-configure-terraform-backend-state

2. Create workspace
    ```
    terraform workspace new <COMPONENT>-<CLOUD>-<ENVIRONMENT>
    ```

    Example:
    ```
    terraform workspace new demo-azure-dev
    ```
### Deploy resources 

switch to working workspace

```
terraform workspace select demo-azure-dev
```

plan terraform
```
terraform plan -var-file dev.tfvars -out dev-plan.tf
```

apply terrafom
```
terraform apply "dev-plan.tf"
```