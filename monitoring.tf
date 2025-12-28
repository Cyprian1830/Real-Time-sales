

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-sales-analytics"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = {
    project = "sales-analytics"
    env     = "dev"
  }
}



resource "azurerm_monitor_diagnostic_setting" "eventhub_diag" {
  name                       = "eventhub-diagnostics"
  target_resource_id         = azurerm_eventhub_namespace.this.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "OperationalLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}



resource "azurerm_monitor_metric_alert" "eventhub_no_incoming" {
  name                = "alert-eventhub-no-incoming"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_eventhub_namespace.this.id]

  description = "Alert when no incoming messages are received by Event Hub"
  severity    = 3
  frequency   = "PT5M"
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.EventHub/namespaces"
    metric_name      = "IncomingMessages"
    aggregation      = "Total"
    operator         = "LessThan"
    threshold        = 1
  }

  enabled = true
}

