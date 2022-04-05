resource "azurerm_linux_virtual_machine" "brunoterraformvm" {
    name                  = "BrunoVM"
    location              = "brazilsouth"
    resource_group_name   = azurerm_resource_group.Exercicio_VM.name
    network_interface_ids = [azurerm_network_interface.vmInterface.id]
    size                  = "Standard_E2bs_v5"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite" 
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "BrunoVm"
    admin_username = "BrunoMendes"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "BrnuoUser"
        public_key     = tls_private_key.vm_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccountbrunovm.primary_blob_endpoint
    }

    depends_on = [ azurerm_resource_group.Exercicio_VM ]
}

output "public_ip_address" {
  value = azurerm_public_ip.vmNetworkIP.ip_address
}