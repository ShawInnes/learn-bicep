@minLength(3)
@maxLength(24)
@description('The name of the storage account to create.')
param name string

@description('The location in which all resources should be deployed.')
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: toLower(replace(name, '-', ''))
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

output storageId string = storageAccount.id
output storageConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value};EndpointSuffix=core.windows.net'
output storagePrimaryAccessKey string = listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value
