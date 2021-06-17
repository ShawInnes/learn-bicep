targetScope = 'subscription'

@description('An array of the allowed locations, all other locations will be denied by the created policy.')
param allowedLocations array = [
  'australiaeast'
  'australiasoutheast'
  'australiacentral'
  'global'
]

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-03-01' = {
  name: 'location-lock'
  properties: {
    policyDefinitionId: policyDefinition.id
  }
}

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-03-01' = {
  name: 'location-restriction'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    parameters: {}
    policyRule: {
      if: {
        allOf: [
          { 
            not: {
              field: 'location'
              in: allowedLocations
            }
          }
          {
            field: 'type'
            equals: 'Microsoft.Resources/subscriptions/resourceGroups'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}
