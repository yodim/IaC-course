resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.prefix}"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.prefix}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-${local.prefix}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# À compléter : le groupe de sécurité réseau (NSG)
# - ressource azurerm_network_security_group "nsg", nommée "nsg-${local.prefix}" dans Azure
# - un bloc security_rule : entrant, TCP, port 22, autorisé, priorité 100
# - source de la règle : var.allowed_ssh_ip


# À compléter : l'association du NSG au sous-réseau
# - ressource azurerm_subnet_network_security_group_association "nsg_subnet"
# - sans elle, le NSG existe mais ne protège rien

