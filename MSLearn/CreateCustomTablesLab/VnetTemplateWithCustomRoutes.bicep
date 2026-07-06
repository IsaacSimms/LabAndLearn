param virtualNetworks_vnet_name string = 'vnet'
param routeTables_publictable_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-ControlTrafficFlow-cus-001/providers/Microsoft.Network/routeTables/publictable'

resource virtualNetworks_vnet_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_vnet_name
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
        name: 'privatesubnet'
        id: virtualNetworks_vnet_name_privatesubnet.id
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'dmzsubnet'
        id: virtualNetworks_vnet_name_dmzsubnet.id
        properties: {
          addressPrefix: '10.0.2.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'publicsubnet'
        id: virtualNetworks_vnet_name_publicsubnet.id
        properties: {
          addressPrefix: '10.0.0.0/24'
          routeTable: {
            id: routeTables_publictable_externalid
          }
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

resource virtualNetworks_vnet_name_dmzsubnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_name}/dmzsubnet'
  properties: {
    addressPrefix: '10.0.2.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_name_resource
  ]
}

resource virtualNetworks_vnet_name_privatesubnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_name}/privatesubnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_name_resource
  ]
}

resource virtualNetworks_vnet_name_publicsubnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_name}/publicsubnet'
  properties: {
    addressPrefix: '10.0.0.0/24'
    routeTable: {
      id: routeTables_publictable_externalid
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_name_resource
  ]
}
