param routeTables_publictable_name string = 'publictable'

resource routeTables_publictable_name_resource 'Microsoft.Network/routeTables@2025-05-01' = {
  name: routeTables_publictable_name
  location: 'centralus'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'productionsubnet'
        id: routeTables_publictable_name_productionsubnet.id
        properties: {
          addressPrefix: '10.0.1.0/24'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.2.4'
        }
      }
    ]
  }
}

resource routeTables_publictable_name_productionsubnet 'Microsoft.Network/routeTables/routes@2025-05-01' = {
  name: '${routeTables_publictable_name}/productionsubnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.2.4'
  }
  dependsOn: [
    routeTables_publictable_name_resource
  ]
}
