param appName string = 'bicep-test'
param environment string = 'prod'

// param sku string = 'Free'
// resource staticSite 'Microsoft.Web/staticSites@2021-01-01' = {
//   name: '${appName}-app'
//   location: resourceGroup().location
//   sku: {
//     tier: sku
//     name: sku
//   }
//   properties: {}
// }

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
