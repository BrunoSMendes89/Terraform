//Rede
resource "azurerm_virtual_network" "vmNetwork" {
  name                = "vmNewtork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Exercicio_VM.location
  resource_group_name = azurerm_resource_group.Exercicio_VM.name

  tags = {
    environment = "vmNetwork"
  }
}

resource "azurerm_subnet" "vmSubNetwork" {
  name                 = "vmSubNetwork"
  resource_group_name  = azurerm_resource_group.Exercicio_VM.name
  virtual_network_name = azurerm_virtual_network.vmNetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "vmNetworkIP" {
  name                    = "publicip"
  location                = azurerm_resource_group.Exercicio_VM.location
  resource_group_name     = azurerm_resource_group.Exercicio_VM.name
  allocation_method       = "Static"

  tags = {
    environment = "publicIP"
  }
}

resource "azurerm_network_security_group" "vmSecurityGroup" {
  name                = "vmNetworkSecurityGroup"
  location            = azurerm_resource_group.Exercicio_VM.location
  resource_group_name = azurerm_resource_group.Exercicio_VM.name

  security_rule {
    name                       = "SecurityVM-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "SecurityGroup"
  }
}

resource "azurerm_network_interface" "vmInterface" {
  name                = "NetworkInterface"
  location            = azurerm_resource_group.Exercicio_VM.location
  resource_group_name = azurerm_resource_group.Exercicio_VM.name

  ip_configuration {
    name                          = "vmInterfaceConfiguration"
    subnet_id                     = azurerm_subnet.vmSubNetwork.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vmNetworkIP.id
  }
}

resource "azurerm_network_interface_security_group_association" "vmAssociation" {
  network_interface_id = azurerm_network_interface.vmInterface.id
  network_security_group_id = azurerm_network_security_group.vmSecurityGroup.id
}

resource "azurerm_storage_account" "mystorageaccountbrunovm" {
    name                        = "storageaccountbrunovm"
    resource_group_name         = azurerm_resource_group.Exercicio_VM.name
    location                    = "brazilsouth"
    account_tier                = "Standard"
    account_replication_type    = "GRS"
}

resource "tls_private_key" "vm_ssh" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.vm_ssh.private_key_pem
  filename        = "key.pem"
  file_permission = "0600"
}