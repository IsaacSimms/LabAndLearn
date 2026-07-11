param virtualMachines_vmLinux_vmbackups_cus_001_name string = 'vmLinux-vmbackups-cus-001'
param disks_vmLinux_vmbackups_cus_001_OsDisk_1_001a1ab3ebb149548c3ce7b7bcc0d2c8_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-vmbackups-cus-001/providers/Microsoft.Compute/disks/vmLinux-vmbackups-cus-001_OsDisk_1_001a1ab3ebb149548c3ce7b7bcc0d2c8'
param networkInterfaces_vmlinux_vmbackups_cus_001147_z1_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-vmbackups-cus-001/providers/Microsoft.Network/networkInterfaces/vmlinux-vmbackups-cus-001147_z1'

resource virtualMachines_vmLinux_vmbackups_cus_001_name_resource 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: virtualMachines_vmLinux_vmbackups_cus_001_name
  location: 'centralus'
  zones: [
    '1'
  ]
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
        name: '${virtualMachines_vmLinux_vmbackups_cus_001_name}_OsDisk_1_001a1ab3ebb149548c3ce7b7bcc0d2c8'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          id: disks_vmLinux_vmbackups_cus_001_OsDisk_1_001a1ab3ebb149548c3ce7b7bcc0d2c8_externalid
        }
        deleteOption: 'Delete'
        diskSizeGB: 2048
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_vmLinux_vmbackups_cus_001_name
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/admin123/.ssh/authorized_keys'
              keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCehtvDDXW+55mxQr9MJaRWSktncBdurDX6WOeJbnqJLE0Fr1UpVbBFZjI5zvlzPzuw7gJE361nZKJlzW37t4C1ZM+OaCDK6yaI2u7IYWEe8cKamDo1Dw2Gi5ndflyC5yKico1rBI3TQ7j7CbLOL7+4O58kRC18H3US3OQ0yXjfNNwvYRPjKwq1eYOMwM9QT2ne7WIMjthWngr0ed576NNcM/lFha8E2m4T0mdPDjyHqH9wi74kSkt93g+W1IQAwPF3z6GNLsALC4pnoscsRg0S2isQTnb+MiNHhJq5wX3ta5J+bkltoUbDNVodIIqyiCr7OeiXd3U0HueeHcKTusxoygj2AKnPZBzUl57AeD2tITXLac1kwRjKaFJb0Pd2kCDsdeAFhs9VDrIThBquFZEW2aPEaNZ1o+8qs0FEBqF1MnunWJw06lWJn084BoIZ1GJ3b0PiRnzhH2Iu4kjiAxtgsAgzSe2ziBd9VZ4RAe7vrQrsLIU/Hq/j9MURPsjjfek= generated-by-azure'
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
      adminUsername: 'admin123'
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
          id: networkInterfaces_vmlinux_vmbackups_cus_001147_z1_externalid
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
