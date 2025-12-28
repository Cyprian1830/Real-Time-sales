resource "azurerm_eventhub_namespace" "this" {
  name                = "eh-sales-analytics"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku      = "Standard"
  capacity = 1

  tags = {
    project = "real-time-sales"
    env     = "dev"
  }
}

resource "azurerm_eventhub" "sales" {
  name                = "sales-events"
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = azurerm_resource_group.rg.name

  partition_count   = 2
  message_retention = 1
}

# Consumer group dedykowana dla Databricks Structured Streaming
resource "azurerm_eventhub_consumer_group" "databricks" {
  name                = "databricks"
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.sales.name
  resource_group_name = azurerm_resource_group.rg.name
}

# Policy tylko do wysyłania zdarzeń (np. generator danych)
resource "azurerm_eventhub_authorization_rule" "send" {
  name                = "send-policy"
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.sales.name
  resource_group_name = azurerm_resource_group.rg.name

  send   = true
  listen = false
  manage = false
}

# Policy tylko do odczytu (Databricks)
resource "azurerm_eventhub_authorization_rule" "listen" {
  name                = "listen-policy"
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.sales.name
  resource_group_name = azurerm_resource_group.rg.name

  send   = false
  listen = true
  manage = false
}

# OUTPUTS (do konfiguracji aplikacji / Databricks)
output "eventhub_namespace" {
  value = azurerm_eventhub_namespace.this.name
}

output "eventhub_name" {
  value = azurerm_eventhub.sales.name
}

output "eventhub_send_connection_string" {
  value     = azurerm_eventhub_authorization_rule.send.primary_connection_string
  sensitive = true
}

output "eventhub_listen_connection_string" {
  value     = azurerm_eventhub_authorization_rule.listen.primary_connection_string
  sensitive = true
}
