
resource "random_string" "pg_suffix" {
  length  = 6
  upper   = false
  special = false
}


resource "azurerm_postgresql_flexible_server" "pg" {
  name                = "pg-sales-${random_string.pg_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  administrator_login    = "pgadmin"
  administrator_password = var.postgres_admin_password

  version = "14"

  sku_name   = "B_Standard_B1ms"   # tania opcja (dev/lab)
  storage_mb = 32768               # 32 GB

  # Publiczny dostęp tylko na potrzeby projektu/labu
  public_network_access_enabled = true

  tags = {
    project = "real-time-sales"
    env     = "dev"
  }
}


resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "salesanalytics"
  server_id = azurerm_postgresql_flexible_server.pg.id
  charset   = "UTF8"
}


resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "allow-all-dev"
  server_id        = azurerm_postgresql_flexible_server.pg.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}


output "postgres_server_name" {
  value = azurerm_postgresql_flexible_server.pg.name
}

output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.pg.fqdn
}

output "postgres_database" {
  value = azurerm_postgresql_flexible_server_database.db.name
}

output "postgres_user" {
  value = azurerm_postgresql_flexible_server.pg.administrator_login
}

