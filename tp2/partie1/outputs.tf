output "public_ip" {
  description = "IP publique de la VM"
  value       = azurerm_public_ip.pip.ip_address
}
