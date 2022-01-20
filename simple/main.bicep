param appName string = 'bicep-test'
param environment string = 'prod'

var keyVaultName = '${appName}-${environment}-kv'

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: resourceGroup().location
  properties: {
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
  }
  
  resource storageSecret 'secrets' = {
    name: 'StorageAccount-ConnectionString'
    properties: {
      value: 'DefaultEndpointsProtocol=https;AccountName=;AccountKey='
    }
  }
}

output keyVaultName string = keyVault.name
output keyVaultId string = keyVault.id

output storageSecretUri string = keyVault::storageSecret.properties.secretUriWithVersion
