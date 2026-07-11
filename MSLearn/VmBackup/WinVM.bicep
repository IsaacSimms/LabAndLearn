param virtualMachines_vm_vmbackups_cus_001_name string = 'vm-vmbackups-cus-001'
param disks_vm_vmbackups_cus_001_OsDisk_1_6966fd1d1d584fc19e7a0eb277984bac_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-vmbackups-cus-001/providers/Microsoft.Compute/disks/vm-vmbackups-cus-001_OsDisk_1_6966fd1d1d584fc19e7a0eb277984bac'
param networkInterfaces_vm_vmbackups_cus_001608_z1_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-vmbackups-cus-001/providers/Microsoft.Network/networkInterfaces/vm-vmbackups-cus-001608_z1'

resource virtualMachines_vm_vmbackups_cus_001_name_resource 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: virtualMachines_vm_vmbackups_cus_001_name
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
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm_vmbackups_cus_001_name}_OsDisk_1_6966fd1d1d584fc19e7a0eb277984bac'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          id: disks_vm_vmbackups_cus_001_OsDisk_1_6966fd1d1d584fc19e7a0eb277984bac_externalid
        }
        deleteOption: 'Delete'
        diskSizeGB: 2048
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: 'vm-vmbackups-cu'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
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
          id: networkInterfaces_vm_vmbackups_cus_001608_z1_externalid
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
