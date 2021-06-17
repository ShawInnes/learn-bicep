param siteName string = 'spa-app'
param sku string = 'Free'

resource staticSite 'Microsoft.Web/staticSites@2021-01-01' = {
  name: siteName
  location: resourceGroup().location
  sku: {
    tier: sku
    name: sku
  }
  properties: {

  }
}

