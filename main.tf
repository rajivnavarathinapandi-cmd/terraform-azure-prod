module "resource_group" {
  source = "./modules/resource-group"

  resource_group_name = "rg-terraform-demo"
  location            = "westeurope"
}

module "vnet" {
  source = "./modules/vnet"

  vnet_name           = "vnet-terraform-demo"
  address_space       = ["10.20.0.0/16"]
  location            = "westeurope"
  resource_group_name = "rg-terraform-demo"
}
module "subnet_web" {
  source = "./modules/subnet"

  subnet_name          = "snet-web"
  resource_group_name  = "rg-terraform-demo"
  virtual_network_name = "vnet-terraform-demo"
  address_prefixes     = ["10.20.1.0/24"]

  nsg_id = module.nsg_web.nsg_id
}

module "subnet_app" {
  source = "./modules/subnet"

  subnet_name          = "snet-app"
  resource_group_name  = "rg-terraform-demo"
  virtual_network_name = "vnet-terraform-demo"
  address_prefixes     = ["10.20.2.0/24"]
}
module "nsg_web" {
  source = "./modules/nsg"

  nsg_name            = "nsg-web"
  location            = "westeurope"
  resource_group_name = "rg-terraform-demo"
}
module "loadbalancer" {

  source = "./modules/loadbalancer"

  location            = "westeurope"
  resource_group_name = "rg-terraform-demo"

}

module "vm_web" {

  source = "./modules/vm"

  vm_name = "vm-web"
  vm_count = 2
  location = "westeurope"

  resource_group_name = "rg-terraform-demo"
  subnet_id = module.subnet_web.subnet_id

  backend_pool_id = module.loadbalancer.backend_pool_id

  admin_username = "azureuser"
  admin_password = "Password1234!"

}
