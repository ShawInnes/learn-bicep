targetScope = 'subscription'

resource policyAssignmentResourceGroup 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'require-naming-on-rg'
  properties: {
    policyDefinitionId: policyDefinitionResourceGroup.id
  }
}

resource policyDefinitionResourceGroup 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'require-naming-on-rg'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    description: 'Requires the proper naming when any resource group is created or updated.'
    metadata: {
      category: 'Naming'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Resources/subscriptions/resourceGroups'
          }
          {
            field: 'name'
            notLike: '*-rg'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource policyAssignmentKeyVault 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'require-naming-on-kv'
  properties: {
    policyDefinitionId: policyDefinitionKeyVault.id
  }
}

resource policyDefinitionKeyVault 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'require-naming-on-kv'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    description: 'Requires the proper naming when any resource group is created or updated.'
    metadata: {
      category: 'Naming'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.KeyVault/vaults'
          }
          {
            field: 'name'
            notLike: '*-kv'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource policyAssignmentStaticWeb 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'require-naming-on-staticweb'
  properties: {
    policyDefinitionId: policyDefinitionStaticWeb.id
  }
}

resource policyDefinitionStaticWeb 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'require-naming-on-staticweb'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    description: 'Requires the proper naming when any resource group is created or updated.'
    metadata: {
      category: 'Naming'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Web/staticSites'
          }
          {
            field: 'name'
            notLike: '*-static'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}
