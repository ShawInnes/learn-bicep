@description('Name of Application Insights.')
param name string

@description('The location where the app insights will reside in.')
param location string = resourceGroup().location

resource ai 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: name
  kind: 'web'
  location: location
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output aiInstrumentationkey string = reference(ai.id, '2014-04-01').InstrumentationKey
