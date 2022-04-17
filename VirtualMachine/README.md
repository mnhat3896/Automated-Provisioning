### Create workspace
```
terraform workspace new <COMPONENT>-<CLOUD>-<ENVIRONMENT>
```

example:
```
terraform workspace new payment-gcp-dev
```
### Deploy resources
init terraform
```
terraform init
```

plan terraform
```
terraform init -var-file dev.auto.tfvars
```