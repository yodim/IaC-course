terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Les identifiants sont lus dans ~/.aws (aws configure) ou dans AWS_PROFILE :
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
