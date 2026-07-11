param sshPublicKeys_test_name string = 'test'
param vaults_vault189_name string = 'vault189'
param virtualNetworks_NorthwindInternal_name string = 'NorthwindInternal'
param virtualMachines_vm_vmbackups_cus_001_name string = 'vm-vmbackups-cus-001'
param virtualMachines_vmLinux_vmbackups_cus_001_name string = 'vmLinux-vmbackups-cus-001'
param publicIPAddresses_vm_vmbackups_cus_001_ip_name string = 'vm-vmbackups-cus-001-ip'
param networkInterfaces_vm_vmbackups_cus_001608_z1_name string = 'vm-vmbackups-cus-001608_z1'
param networkSecurityGroups_vm_vmbackups_cus_001_nsg_name string = 'vm-vmbackups-cus-001-nsg'
param publicIPAddresses_vmLinux_vmbackups_cus_001_ip_name string = 'vmLinux-vmbackups-cus-001-ip'
param networkInterfaces_vmlinux_vmbackups_cus_001147_z1_name string = 'vmlinux-vmbackups-cus-001147_z1'
param networkSecurityGroups_vmLinux_vmbackups_cus_001_nsg_name string = 'vmLinux-vmbackups-cus-001-nsg'

resource sshPublicKeys_test_name_resource 'Microsoft.Compute/sshPublicKeys@2025-11-01' = {
  name: sshPublicKeys_test_name
  location: 'centralus'
  properties: {
    publicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCehtvDDXW+55mxQr9MJaRWSktncBdurDX6WOeJbnqJLE0Fr1UpVbBFZjI5zvlzPzuw7gJE361nZKJlzW37t4C1ZM+OaCDK6yaI2u7IYWEe8cKamDo1Dw2Gi5ndflyC5yKico1rBI3TQ7j7CbLOL7+4O58kRC18H3US3OQ0yXjfNNwvYRPjKwq1eYOMwM9QT2ne7WIMjthWngr0ed576NNcM/lFha8E2m4T0mdPDjyHqH9wi74kSkt93g+W1IQAwPF3z6GNLsALC4pnoscsRg0S2isQTnb+MiNHhJq5wX3ta5J+bkltoUbDNVodIIqyiCr7OeiXd3U0HueeHcKTusxoygj2AKnPZBzUl57AeD2tITXLac1kwRjKaFJb0Pd2kCDsdeAFhs9VDrIThBquFZEW2aPEaNZ1o+8qs0FEBqF1MnunWJw06lWJn084BoIZ1GJ3b0PiRnzhH2Iu4kjiAxtgsAgzSe2ziBd9VZ4RAe7vrQrsLIU/Hq/j9MURPsjjfek= generated-by-azure'
  }
}

resource networkSecurityGroups_vmLinux_vmbackups_cus_001_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_vmLinux_vmbackups_cus_001_nsg_name
  location: 'centralus'
  properties: {
    securityRules: [
      {
        name: 'SSH'
        id: networkSecurityGroups_vmLinux_vmbackups_cus_001_nsg_name_SSH.id
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_vm_vmbackups_cus_001_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_vm_vmbackups_cus_001_nsg_name
  location: 'centralus'
  properties: {
    securityRules: [
      {
        name: 'RDP'
        id: networkSecurityGroups_vm_vmbackups_cus_001_nsg_name_RDP.id
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_vmLinux_vmbackups_cus_001_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_vmLinux_vmbackups_cus_001_ip_name
  location: 'centralus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    ipAddress: '172.202.113.1'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource publicIPAddresses_vm_vmbackups_cus_001_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_vm_vmbackups_cus_001_ip_name
  location: 'centralus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    ipAddress: '52.165.90.252'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_NorthwindInternal_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_NorthwindInternal_name
  location: 'centralus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: '${virtualNetworks_NorthwindInternal_name}1'
        id: virtualNetworks_NorthwindInternal_name_virtualNetworks_NorthwindInternal_name_1.id
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource vaults_vault189_name_resource 'Microsoft.RecoveryServices/vaults@2026-02-01' = {
  name: vaults_vault189_name
  location: 'centralus'
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    securitySettings: {
      softDeleteSettings: {
        softDeleteRetentionPeriodInDays: 14
        softDeleteState: 'Enabled'
        enhancedSecurityState: 'Enabled'
      }
      sourceScanConfiguration: {
        state: 'Disabled'
      }
    }
    redundancySettings: {
      standardTierStorageRedundancy: 'GeoRedundant'
      crossRegionRestore: 'Disabled'
    }
    publicNetworkAccess: 'Enabled'
    restoreSettings: {
      crossSubscriptionRestoreSettings: {
        crossSubscriptionRestoreState: 'Enabled'
      }
    }
  }
}

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
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vmLinux_vmbackups_cus_001_name}_OsDisk_1_001a1ab3ebb149548c3ce7b7bcc0d2c8'
          )
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
          id: networkInterfaces_vmlinux_vmbackups_cus_001147_z1_name_resource.id
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
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_vmbackups_cus_001_name}_OsDisk_1_6966fd1d1d584fc19e7a0eb277984bac'
          )
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
          id: networkInterfaces_vm_vmbackups_cus_001608_z1_name_resource.id
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

resource networkSecurityGroups_vm_vmbackups_cus_001_nsg_name_RDP 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_vm_vmbackups_cus_001_nsg_name}/RDP'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_vm_vmbackups_cus_001_nsg_name_resource
  ]
}

resource networkSecurityGroups_vmLinux_vmbackups_cus_001_nsg_name_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_vmLinux_vmbackups_cus_001_nsg_name}/SSH'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_vmLinux_vmbackups_cus_001_nsg_name_resource
  ]
}

resource virtualNetworks_NorthwindInternal_name_virtualNetworks_NorthwindInternal_name_1 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_NorthwindInternal_name}/${virtualNetworks_NorthwindInternal_name}1'
  properties: {
    addressPrefix: '10.0.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_NorthwindInternal_name_resource
  ]
}

resource vaults_vault189_name_DefaultPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2026-02-01' = {
  parent: vaults_vault189_name_resource
  name: 'DefaultPolicy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V1'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2026-07-11T13:00:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2026-07-11T13:00:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'UTC'
    protectedItemsCount: 0
  }
}

resource vaults_vault189_name_EnhancedPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2026-02-01' = {
  parent: vaults_vault189_name_resource
  name: 'EnhancedPolicy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V2'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicyV2'
      scheduleRunFrequency: 'Hourly'
      hourlySchedule: {
        interval: 4
        scheduleWindowStartTime: '2026-07-11T08:00:00Z'
        scheduleWindowDuration: 12
      }
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2026-07-11T08:00:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'UTC'
    protectedItemsCount: 0
  }
}

resource vaults_vault189_name_EnhancedPolicy_mrfs2770 'Microsoft.RecoveryServices/vaults/backupPolicies@2026-02-01' = {
  parent: vaults_vault189_name_resource
  name: 'EnhancedPolicy-mrfs2770'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V2'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicyV2'
      scheduleRunFrequency: 'Hourly'
      hourlySchedule: {
        interval: 4
        scheduleWindowStartTime: '2021-07-26T08:00:00Z'
        scheduleWindowDuration: 12
      }
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2021-07-26T08:00:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 7
    timeZone: 'UTC'
    protectedItemsCount: 0
  }
}

resource vaults_vault189_name_HourlyLogBackup 'Microsoft.RecoveryServices/vaults/backupPolicies@2026-02-01' = {
  parent: vaults_vault189_name_resource
  name: 'HourlyLogBackup'
  properties: {
    backupManagementType: 'AzureWorkload'
    workLoadType: 'SQLDataBase'
    settings: {
      timeZone: 'UTC'
      issqlcompression: false
      isCompression: false
    }
    subProtectionPolicy: [
      {
        policyType: 'Full'
        schedulePolicy: {
          schedulePolicyType: 'SimpleSchedulePolicy'
          scheduleRunFrequency: 'Daily'
          scheduleRunTimes: [
            '2026-07-11T13:00:00Z'
          ]
          scheduleWeeklyFrequency: 0
        }
        retentionPolicy: {
          retentionPolicyType: 'LongTermRetentionPolicy'
          dailySchedule: {
            retentionTimes: [
              '2026-07-11T13:00:00Z'
            ]
            retentionDuration: {
              count: 30
              durationType: 'Days'
            }
          }
        }
      }
      {
        policyType: 'Log'
        schedulePolicy: {
          schedulePolicyType: 'LogSchedulePolicy'
          scheduleFrequencyInMins: 60
        }
        retentionPolicy: {
          retentionPolicyType: 'SimpleRetentionPolicy'
          retentionDuration: {
            count: 30
            durationType: 'Days'
          }
        }
      }
    ]
    protectedItemsCount: 0
  }
}

resource vaults_vault189_name_defaultAlertSetting 'Microsoft.RecoveryServices/vaults/replicationAlertSettings@2026-02-01' = {
  parent: vaults_vault189_name_resource
  name: 'defaultAlertSetting'
  properties: {
    sendToOwners: 'DoNotSend'
    customEmailAddresses: []
  }
}

resource vaults_vault189_name_default 'Microsoft.RecoveryServices/vaults/replicationVaultSettings@2026-02-01' = {
  parent: vaults_vault189_name_resource
  name: 'default'
  properties: {}
}

resource networkInterfaces_vmlinux_vmbackups_cus_001147_z1_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_vmlinux_vmbackups_cus_001147_z1_name
  location: 'centralus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vmlinux_vmbackups_cus_001147_z1_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.0.0.5'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_vmLinux_vmbackups_cus_001_ip_name_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: virtualNetworks_NorthwindInternal_name_virtualNetworks_NorthwindInternal_name_1.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_vmLinux_vmbackups_cus_001_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_vm_vmbackups_cus_001608_z1_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_vm_vmbackups_cus_001608_z1_name
  location: 'centralus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_vmbackups_cus_001608_z1_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_vm_vmbackups_cus_001_ip_name_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: virtualNetworks_NorthwindInternal_name_virtualNetworks_NorthwindInternal_name_1.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_vm_vmbackups_cus_001_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
