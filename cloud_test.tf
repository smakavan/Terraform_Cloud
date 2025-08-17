terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

# here i have modified secrets
provider "azurerm" {
  features {}
  client_id       = "8fc21970-be2a-446d-8f66-67d88c7f2b50"
  client_secret   = "s4G8Q~ReZ4v_mLdaH7h_XuygVzJ3cYpTIarILai0"
  tenant_id       = "c761b29e-6ae0-4b0e-ac0b-cb030b4b4b30"
  subscription_id = "5fd92075-bce6-4a41-ba79-266a440ff070"
}


terraform {
  cloud {

    organization = "smakavan_17Aug"

    workspaces {
      name = "terraform_local"
    }
  }
}



variable "rgname" {
  default = "cloud-test1"
}

variable "rglocation" {
  default = "west us 2"
}

resource "azurerm_resource_group" "rg_test" {
  name     = var.rgname
  location = var.rglocation
}
