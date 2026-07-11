param virtualNetworks_NorthwindInternal_name string = 'NorthwindInternal'

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
