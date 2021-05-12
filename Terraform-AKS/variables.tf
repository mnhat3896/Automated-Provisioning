
variable "resource_group_name" {
  description = "The resource_group_name is used for Kubernetes's resource"
  default = "rg-k8s_XXXX-systemtest"
}

variable "location" {
  description = "Define the location you want to put these resources to. (example: Southeast Asia) "
  default = "Southeast Asia"
}
# ===============================================

variable "tags" {
  default = {
    project-env = "XXXX-systemtest"
  }
}

variable "cluster_name" {
  default = "aks-XXXX-systemtest"
}

variable "dns_prefix" {
  default = "XXXX-systemtest-dns"
  description = "DNS name prefix to use with the hosted Kubernetes API server. Use this to connect to the Kubernetes API when managing containers after creating the cluster."
}

# ====== variable for AUTOMATION ACCOUNT ======

variable "am_variable_subcription_id" {
  description = "This is Subscription's Id variable used for automation-account's variable"
}

# ====== variable for STORAGE ACCOUNT ======
variable "storage_account_name" {
  default = "saXXXXsystest"
}

variable "storage_account_container_name1" {
  default = "cvapp-apply"
}

variable "storage_account_container_name2" {
  default = "systemtest"
}

# ====== variable for SERVICEBUS ======
variable "servicebus_name" {
  default = "sb-XXXX-systemtest"
}

# ====== variable for K8S ======
variable "k8s_linux_profile_username" {
  default = "sysadmin"
  description = "this is username for linux os of nodes"
}

variable "k8s_node_count" {
  default = 2
}

variable "k8s_vm_size" {
  default = "Standard_B2ms"
}

variable "k8s_version" {
  default = "1.18.10"
}

variable "k8s_node_pool_type" {
  default = "VirtualMachineScaleSets"
}

variable "k8s_node_pool_enable_auto_scaling" {
  default = false
}
