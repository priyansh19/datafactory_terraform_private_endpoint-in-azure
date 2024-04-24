resource "azurerm_resource_group" "SPGC_DF_RG" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "SPGC_DF_VNET" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.SPGC_DF_RG.location
  resource_group_name = azurerm_resource_group.SPGC_DF_RG.name
}

resource "azurerm_subnet" "SPGC_DF_SUBNET" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.SPGC_DF_RG.name
  virtual_network_name = azurerm_virtual_network.SPGC_DF_VNET.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_data_factory" "SPGC_DF" {
  name                = var.data_factory_name
  location            = azurerm_resource_group.SPGC_DF_RG.location
  resource_group_name = azurerm_resource_group.SPGC_DF_RG.name
}

resource "azurerm_private_endpoint" "SPGC_DF_PE" {
  name                = var.private_endpoint_name
  depends_on = [ azurerm_data_factory.SPGC_DF, azurerm_virtual_network.SPGC_DF_VNET, azurerm_subnet.SPGC_DF_SUBNET ]
  location            = azurerm_resource_group.SPGC_DF_RG.location
  resource_group_name = azurerm_resource_group.SPGC_DF_RG.name
  subnet_id           = azurerm_subnet.SPGC_DF_SUBNET.id
  private_service_connection {
    name        = "datafactory-private-endpoint-connection"
    is_manual_connection = false
    private_connection_resource_id = azurerm_data_factory.SPGC_DF.id
    subresource_names = ["dataFactory"]
  }
}

resource "azurerm_private_endpoint" "SPGC_DF_PORTAL_PE" {
  name                = var.private_endpoint_portal_name
  depends_on = [ azurerm_data_factory.SPGC_DF, azurerm_virtual_network.SPGC_DF_VNET, azurerm_subnet.SPGC_DF_SUBNET ]
  location            = azurerm_resource_group.SPGC_DF_RG.location
  resource_group_name = azurerm_resource_group.SPGC_DF_RG.name
  subnet_id           = azurerm_subnet.SPGC_DF_SUBNET.id
  private_service_connection {
    name        = "datafactory-portal-private-endpoint-connection"
    is_manual_connection = false
    private_connection_resource_id = azurerm_data_factory.SPGC_DF.id
    subresource_names = ["dataFactory"]
  }
}