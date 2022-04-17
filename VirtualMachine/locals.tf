locals {
  common_labels = {
    environment = "%{ if terraform.workspace != "default" }${split("-",terraform.workspace)[2]}%{ else }${terraform.workspace}%{ endif }"
    location    = var.location
  }
}