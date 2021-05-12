resource "azurerm_servicebus_namespace" "sb" {
  name                = var.servicebus_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  depends_on          = [azurerm_kubernetes_cluster.k8s]
  tags                = var.tags
}

resource "azurerm_servicebus_queue" "sb_queue1" {
  name                = ""
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  depends_on          = [azurerm_kubernetes_cluster.k8s]
  enable_partitioning = false
}

resource "azurerm_servicebus_queue" "sb_queue2" {
  name                = ""
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  depends_on          = [azurerm_kubernetes_cluster.k8s]
  enable_partitioning = false
}

resource "azurerm_servicebus_queue" "sb_queue3" {
  name                = ""
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  depends_on          = [azurerm_kubernetes_cluster.k8s]
  enable_partitioning = false
}

resource "azurerm_servicebus_topic" "sb_topic_hr" {
  name                = ""
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  depends_on          = [azurerm_kubernetes_cluster.k8s]
  enable_partitioning = false
}

resource "azurerm_servicebus_topic" "sb_topic_candidate" {
  name                = ""
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  depends_on          = [azurerm_kubernetes_cluster.k8s]
  enable_partitioning = false
}

resource "azurerm_servicebus_topic" "sb_topic_responsivehr" {
  name                = ""
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  depends_on          = [azurerm_kubernetes_cluster.k8s]
  enable_partitioning = false
}

resource "azurerm_servicebus_subscription" "sb_topic_subscription1" {
  name                = ""
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  topic_name          = azurerm_servicebus_topic.sb_topic_hr.name
  max_delivery_count  = 1500
  depends_on          = [azurerm_kubernetes_cluster.k8s]
}

resource "azurerm_servicebus_subscription" "sb_topic_subscription2" {
  name                = ""
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sb.name
  topic_name          = azurerm_servicebus_topic.sb_topic_candidate.name
  max_delivery_count  = 1500
  depends_on          = [azurerm_kubernetes_cluster.k8s]
}
