@description('Name of Azure Function.')
param name string

@description('The location where the app insights will reside in.')
param location string = resourceGroup().location

@description('Application settings to pass to the AppConfig.')
param appConfig array

param aiInstrumentationKey string

param appServicePlan string

var coreAppConfig = [
  {
    'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
    'value': aiInstrumentationKey
  }
  {
    'name': 'FUNCTIONS_EXTENSION_VERSION'
    'value': '~3'
  }
  {
    'name': 'FUNCTIONS_WORKER_RUNTIME'
    'value': 'dotnet'
  }
]

resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
  name: name
  location: location
  kind: 'functionapp'
  properties: {
    httpsOnly: true
    serverFarmId: appServicePlan
    clientAffinityEnabled: true
    siteConfig: {
      // appSettings: union(coreAppConfig, appConfig)
    }
  }
}
