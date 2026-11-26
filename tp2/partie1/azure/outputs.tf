# À décommenter à l'étape 5, une fois l'IP publique écrite dans vm.tf :
# tant que la ressource n'existe pas, terraform validate refuse cette référence.
#
# output "public_ip" {
#   description = "IP publique de la VM"
#   value       = azurerm_public_ip.pip.ip_address
# }
