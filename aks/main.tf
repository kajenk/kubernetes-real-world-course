terraform {
   backend "azurerm" {
    resource_group_name  = "terraformstate"
    storage_account_name = "tfstatesbackend365"
    container_name       = "tfbackend"
    key                  = "aks_lab.terraform.tfstate"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "devrg" {
  name               = var.resource_group_name
 location            = var.location
}
resource "azurerm_kubernetes_cluster" "k8squickstart" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name}-dns01"

  kubernetes_version = var.k8s_version

  
  network_profile {
  network_plugin = "azure"
  network_policy = "azure"
}

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_A2_v2"
    
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
  depends_on = [
    azurerm_resource_group.devrg
  ]
}
