provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "resourceForContainer" {
  name     = var.RESOURCE_GROUP
  location = var.LOCATION
}

resource "azurerm_container_group" "example" {
  name                = var.CONTAINER_NAME
  location            = "${azurerm_resource_group.resourceForContainer.location}"
  resource_group_name = "${azurerm_resource_group.resourceForContainer.name}"
  dns_name_label      = var.CONTAINER_NAME
  ip_address_type     = "Public"
  os_type = "Linux"

  container {
    name   = var.CONTAINER_NAME
    image  = var.CONTAINER_IMAGE
    cpu    = "1.0"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
  depends_on = [
    azurerm_resource_group.resourceForContainer
  ]

}