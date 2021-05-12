# Resource-Run-Monitor
- Use Terraform to provisioning VM, VNET, Subnet, Keyvault, NSG, NIC, TLS Key on Azure
- Use Ansible to configuration elasticsearch, prometheus, grafana, kibana base on docker except nginx
### Folow:
- Create Storage Account to store Terraform's stage (backend)
- Provisioning resource with Terraform (dynamic backend when run terraform.sh)
- Create container elasticsearch, kibana,...etc. with Ansible (dynamic inventory when run ansible.sh)
- Install Nginx

### NOTE:
The main.sh is only used to test on local. If need you can to convert those steps to pipeline for automation, check reference below

    - Terraform on azure pipeline: https://azuredevopslabs.com/labs/vstsextend/terraform/
    - Ansible on azure pipeline: https://codingwithtaz.blog/2020/06/01/iac-ansible-with-azure-pipelines/

---

# Terraform-AKS

- Use Terraform to provisioning AKS
