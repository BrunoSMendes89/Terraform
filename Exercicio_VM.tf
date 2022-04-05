terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

//Pasta do exercicio
resource "azurerm_resource_group" "Exercicio_VM" {
    name = "MaquinaVirtualBruno"
    location = "brazilsouth"
}