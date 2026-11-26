# À compléter : l'IP publique
# - ressource azurerm_public_ip "pip", nommée "pip-${local.prefix}" dans Azure
# - sku = "Standard", allocation_method = "Static"


# À compléter : la carte réseau
# - ressource azurerm_network_interface "nic", nommée "nic-${local.prefix}" dans Azure
# - bloc ip_configuration : subnet_id, private_ip_address_allocation = "Dynamic",
#   public_ip_address_id


# À compléter : la machine virtuelle
# - ressource azurerm_linux_virtual_machine "vm", nommée "vm-${local.prefix}" dans Azure
# - size, admin_username, network_interface_ids, admin_ssh_key,
#   os_disk (caching, storage_account_type), source_image_reference
#
# Les deux blocs ci-dessous sont à placer dans la ressource :
#
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "ubuntu-24_04-lts"
#     sku       = "server"
#     version   = "latest"
#   }
#
#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

