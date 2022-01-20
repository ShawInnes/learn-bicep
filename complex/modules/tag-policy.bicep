targetScope = 'subscription'

param location string

@description('An array of the required tags.')
param tagNames array = []

resource policyAssignmentResourceGroup 'Microsoft.Authorization/policyAssignments@2020-09-01' = [for name in tagNames: {
  name: 'require-tag-${name}-on-rg'
  properties: {
    policyDefinitionId: policyDefinitionResourceGroup.id
    parameters: {
      tagName: {
        value: '${name}'
      }
    }
  }
}]

resource policyDefinitionResourceGroup 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
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

resource policyAssignmentResource 'Microsoft.Authorization/policyAssignments@2020-09-01' = [for name in tagNames: {
  name: 'inherit-tag-${name}-from-rg'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    policyDefinitionId: policyDefinitionResource.id
    parameters: {
      tagName: {
        value: '${name}'
      }
    }
  }
}]

resource policyDefinitionResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'inherit-tag-from-rg'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    description: 'Appends the specified tag with its value from the resource group when any resource which is missing this tag is created or updated.'
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
            field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
            exists: 'false'
          }
          {
            not: {
              field: 'type'
              in: [
                'Microsoft.Resources/subscriptions/resourceGroups'
                'Microsoft.Network/frontdoorwebapplicationfirewallpolicies'
                'microsoft.insights/actionGroups'
                'microsoft.insights/components'
                'Microsoft.Network/dnszones'
                'Microsoft.Network/frontdoors'
              ]
            }
          }
        ]
      }
      then: {
        effect: 'modify'
        details: {
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          operations: [
            {
              operation: 'add'
              field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
              value: '[resourceGroup().tags[parameters(\'tagName\')]]'
            }
          ]
        }
      }
    }
  }
}
