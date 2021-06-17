targetScope = 'subscription'

@description('An array of the required tags.')
param tagNames array = [
  'owner'
]

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = [for name in tagNames: {
  name: 'require-tag-${name}-on-rg'
  properties: {
    policyDefinitionId: policyDefinition.id
    parameters: {
      tagName: {
        value: '${name}'
      }
    }
  }  
}]

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'require-tag-on-rg'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    description: 'Requires the specified tag when any resource group is created or updated.'
    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'Tag Name'
          description: 'Name of the tag, such as "environment"'
        }
      }
    }
    metadata: {
      category: 'Tags'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Resources/subscriptions/resourceGroups'
          }
          {
            field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
            exists: false
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}
