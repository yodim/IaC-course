variable "groupe" {
  description = "Identifiant du groupe, par exemple g1"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
  default     = "francecentral"
}

variable "vm_size" {
  description = "Taille de la machine virtuelle"
  type        = string
  default     = "Standard_B1s"

  validation {
    condition = contains(
      ["Standard_B1s", "Standard_B2s"], var.vm_size
    )
    error_message = "Taille non autorisée."
  }
}

variable "admin_username" {
  description = "Utilisateur administrateur de la VM"
  type        = string
  default     = "azureuser"
}

variable "allowed_ssh_ip" {
  description = "IP publique de la salle, seule autorisée en SSH"
  type        = string
}

locals {
  prefix = "tp2-${var.groupe}"
}
