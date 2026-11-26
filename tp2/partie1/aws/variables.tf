variable "groupe" {
  description = "Identifiant du groupe, par exemple g1"
  type        = string
}

variable "region" {
  description = "Région AWS (eu-west-3 = Paris)"
  type        = string
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small"], var.instance_type)
    error_message = "Type non autorisé : t3.micro ou t3.small (éligibles à l'offre gratuite)."
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

  # AWS n'accepte que des plages CIDR : une IP seule devient une plage /32.
  ssh_cidr = strcontains(var.allowed_ssh_ip, "/") ? var.allowed_ssh_ip : "${var.allowed_ssh_ip}/32"
}
