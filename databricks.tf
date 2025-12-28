resource "azurerm_databricks_workspace" "this" {
  name                = "dbw-sales-analytics"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"

  sku = "standard"

  managed_resource_group_name = "rg-dbw-sales-managed"

  tags = {
    project = "real-time-sales"
    env     = "dev"
  }
}

output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.this.workspace_url
}
