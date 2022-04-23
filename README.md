# Resource-Run-Monitor
- Use Terraform to provisioning VM, VNET, Subnet, Keyvault, NSG, NIC, TLS Key on Azure
- Use Ansible to configuration docker, nginx
### Folow:
- Create Storage Account to store Terraform's stage (backend)
- Install Nginx (dynamic inventory when run ansible.sh)

### Run scrip base on order
1. ./terraform.sh (provisioning bucket backend)
2. ./main.sh (run ansible-playbook)

### NOTE:
The main.sh is only used to test on local. If need you can to convert those steps to pipeline for automation, check reference below

    - Terraform on azure pipeline: https://azuredevopslabs.com/labs/vstsextend/terraform/
    - Ansible on azure pipeline: https://codingwithtaz.blog/2020/06/01/iac-ansible-with-azure-pipelines/

---

# Terraform-AKS

- Use Terraform to provisioning AKS

# VirtualMachine

- Provisioning Linux instance with LB
