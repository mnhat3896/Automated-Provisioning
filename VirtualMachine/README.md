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
terraform init -backend-config=dev.backend
```

plan terraform
```
terraform plan -var-file dev.tfvars
```