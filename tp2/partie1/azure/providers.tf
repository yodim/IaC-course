terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

# L'identifiant de l'abonnement est lu dans ARM_SUBSCRIPTION_ID.
# Depuis AzureRM 5.0, les fournisseurs de ressources ne sont plus
# enregistrés automatiquement : on liste ceux dont on a besoin.
provider "azurerm" {
  resource_providers_to_register = [
    "Microsoft.Compute",
    "Microsoft.Network",
  ]
  features {}
}
