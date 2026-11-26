terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.23"
    }
  }
}

# Les identifiants viennent de la session aws login (provider 6.23 ou plus récent),
# ou de ~/.aws/credentials après aws configure :
# rien de secret n'est écrit dans le code.
provider "aws" {
  region = var.region

  # Étiquettes ajoutées à toutes les ressources qui en acceptent.
  default_tags {
    tags = {
      cours  = "iac"
      tp     = "tp2"
      groupe = var.groupe
    }
  }
}
