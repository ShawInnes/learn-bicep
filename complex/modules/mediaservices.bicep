@description('Name of Azure Function.')
param name string

param storageAccountId string

@description('The location where the app insights will reside in.')
param location string = resourceGroup().location

resource mediaServices 'Microsoft.Media/mediaServices@2020-05-01' = {
  name: name
  location: location
  properties: {
    storageAccounts: [
      {
        id: storageAccountId
        type: 'Primary'
      }
    ]
  }
}
