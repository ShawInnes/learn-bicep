param name string

@description('The location where this resource will reside')
param location string = resourceGroup().location

param appConfig array

param appServicePlanId string
param aiInstrumentationKey string

var coreAppConfig = [
  {
    'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
    'value': aiInstrumentationKey
  }
]
resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: name
  location: location
  kind: 'app,windows'
  properties: {
    enabled: true
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      windowsFxVersion: 'DOTNETCORE|5.0'
      httpLoggingEnabled: true
      appSettings: union(coreAppConfig, appConfig)
    }
  }
}
