param virtualMachines_vm_AzureMonitorLab_cus_001_name string = 'vm-AzureMonitorLab-cus-001'
param disks_vm_AzureMonitorLab_cus_001_OsDisk_1_3dcfdf200e2642d38a1893824fbc31eb_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-AzureMonitorLab-cus-001/providers/Microsoft.Compute/disks/vm-AzureMonitorLab-cus-001_OsDisk_1_3dcfdf200e2642d38a1893824fbc31eb'
param networkInterfaces_vm_azuremonitorlab_cus_001496_z1_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-AzureMonitorLab-cus-001/providers/Microsoft.Network/networkInterfaces/vm-azuremonitorlab-cus-001496_z1'

resource virtualMachines_vm_AzureMonitorLab_cus_001_name_resource 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: virtualMachines_vm_AzureMonitorLab_cus_001_name
  location: 'centralus'
  zones: [
    '1'
  ]
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_vm_AzureMonitorLab_cus_001_name}_OsDisk_1_3dcfdf200e2642d38a1893824fbc31eb'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: disks_vm_AzureMonitorLab_cus_001_OsDisk_1_3dcfdf200e2642d38a1893824fbc31eb_externalid
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_vm_AzureMonitorLab_cus_001_name
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/azureuser/.ssh/authorized_keys'
              keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJcLD51GOQQfz+b2YecYaUNb9FC3n2wn8DP6BiBJKQDEr/piQkDtKRXESe0b6TEShuuj6qF5TmRgKsAp3kEDwz+0MmLDU7lJFrp7rxav9EegNx6aHsNKvY2oXeR5yEotCA0ewe61UdfjdTv+dFLK9HIxgRG0Jl0Gri5g17u9SbzYWg+3TkM5r9JFaGL5jaR4SlWd8xrQA7fWiMpkmhEK3shwlCEvmmE7gqBUhwAJ4HITuoSswlPliT3g8P0nPIosAou2Zy4OE2S9IwGvp6e6jKGQP7Af+L3Z208G5PMrKB+7VGRvShDwe2jPwUa+g/iCnXGu67fm0I3zzrCoSYELt4Vqv9xAomkm33v7l50mp3klGy3aKUCVH3giqoS7K+3dwnBE/KXl+opLcUIV+NKR55pQi8GLfLcXjkSbvqB0DNpiP6EjD+wVvLviVAZJt5Qz7VI+zgmxpj87iAn+lAhZZSs0yszCGvbfvVZR5ZjAidajE5/Sq2pn6oQYIg8V0r5Uk= generated-by-azure'
            }
          ]
        }
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_azuremonitorlab_cus_001496_z1_externalid
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
