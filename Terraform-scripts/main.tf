terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.52.0"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name = "terraform-state"
    storage_account_name = "terraformstatetitiksha"
    container_name       = "titiksha-terraform-state"
    key                  = "terraform.tfstate"
    # access_key           = Passed in as Parameter to Terraform CLI
  }
}
provider "azurerm" {
    subscription_id = var.AZURE_SUBSCRIPTION_ID
    client_id       = var.SERVICE_PRINCIPAL_ID
    client_secret   = var.SERVICE_PRINCIPAL_PASSWORD
    tenant_id       = var.AZURE_TENANT_ID
    features {}
}

resource "azurerm_resource_group" "resourceForContainer" {
  name     = var.RESOURCE_GROUP
  location = var.LOCATION
}

resource "azurerm_container_group" "titiksha_container_group" {
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



resource "azurerm_traffic_manager_profile" "titiksha_traffic_manager" {
  name                   = "titiksha"
  resource_group_name    = azurerm_resource_group.resourceForContainer.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "titiksha"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

}

resource "azurerm_traffic_manager_external_endpoint" "example" {
  name       = "example-endpoint"
  profile_id = azurerm_traffic_manager_profile.titiksha_traffic_manager.id
  endpoint_location = azurerm_container_group.titiksha_container_group.location
  target     = azurerm_container_group.titiksha_container_group.fqdn
}