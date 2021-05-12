resource "azurerm_automation_account" "am" {
  name                = "automationAccountSystemtest"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name = "Basic"
  tags = var.tags
  depends_on          = [azurerm_kubernetes_cluster.k8s]
}

resource "azurerm_automation_runbook" "am_runbook" {
  name                    = "amRunbook"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.am.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "automatic start and stop VMss follow the schedule"
  runbook_type            = "PowerShell"
  content                 = data.local_file.start_stop_vmss_file.content
  depends_on              = [azurerm_kubernetes_cluster.k8s]
}

resource "azurerm_automation_schedule" "am_start_schedule" {
  name                    = "Start-VMss"
  resource_group_name     =  var.resource_group_name
  automation_account_name =  azurerm_automation_account.am.name
  frequency               = "Week"
  interval                = 1
  timezone                = "Asia/Ho_Chi_Minh"
  start_time              = "2020-12-21T07:00:00+00:00"
  description             = "schedule tim for start VMss"
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  depends_on              = [azurerm_kubernetes_cluster.k8s]
}

resource "azurerm_automation_schedule" "am_stop_schedule" {
  name                    = "Stop-VMss"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.am.name
  frequency               = "Week"
  interval                = 1
  timezone                = "Asia/Ho_Chi_Minh"
  start_time              = "2020-12-21T21:00:00+00:00"
  description             = "schedule tim for stop VMss"
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  depends_on              = [azurerm_kubernetes_cluster.k8s]
}

resource "azurerm_automation_variable_string" "am_variable_string1" {
  name                    = "Internal_ResourceGroupName"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.am.name
  value                   = var.resource_group_name
  depends_on              = [azurerm_kubernetes_cluster.k8s]
}

resource "azurerm_automation_variable_string" "am_variable_string2" {
  name                    = "Internal_AzureSubscriptionId"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.am.name
  value                   = var.am_variable_subcription_id
  depends_on              = [azurerm_kubernetes_cluster.k8s]
}

resource "azurerm_automation_job_schedule" "am_job_start" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.am.name
  schedule_name           = azurerm_automation_schedule.am_start_schedule.name
  runbook_name            = azurerm_automation_runbook.am_runbook.name
  depends_on              = [azurerm_kubernetes_cluster.k8s]

  parameters = {
    action = "Start"
  }
}

resource "azurerm_automation_job_schedule" "am_job_stop" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.am.name
  schedule_name           = azurerm_automation_schedule.am_stop_schedule.name
  runbook_name            = azurerm_automation_runbook.am_runbook.name
  depends_on              = [azurerm_kubernetes_cluster.k8s]
  parameters = {
    action = "Stop"
  }
}
