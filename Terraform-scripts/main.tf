provider "azurerm" {
    subscription_id = "${AZURE_SUBSCRIPTION_ID}"
    client_id       = "${SERVICE_PRINCIPAL_ID}"
    client_secret   = "${SERVICE_PRINCIPAL_PASSWORD}"
    tenant_id       = "${AZURE_TENANT_ID}"
    features {}
}

resource "azurerm_resource_group" "resourceForContainer" {
  name     = "${RESOURCE_GROUP}"
  location = "${LOCATION}"
}

resource "azurerm_container_group" "example" {
  name                = "${CONTAINER_NAME}"
  location            = "${azurerm_resource_group.resourceForContainer.location}"
  resource_group_name = "${azurerm_resource_group.resourceForContainer.name}"
  dns_name_label      = "${CONTAINER_NAME}"
  ip_address_type     = "Public"
  os_type = "Linux"

  container {
    name   = "${CONTAINER_NAME}"
    image  = "${docker_registry}:${imageTag}"
    cpu    = "1.0"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }


}