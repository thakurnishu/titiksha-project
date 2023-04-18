terraform {
  backend "azurerm" {
    storage_account_name = var.STORAGE_NAME
    container_name       = var.STORAGE_CONTAINER
    key                  = "terraform.tfstate"
    access_key           = var.STORAGE_KEY
  }
}