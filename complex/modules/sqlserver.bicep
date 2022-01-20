param name string
param sqlAdminLogin string
param sqlAdminPassword string

@description('The location where this resource will reside')
param location string = resourceGroup().location

resource appService 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: name
  location: location
  properties: {
    version: '12.0'
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}
