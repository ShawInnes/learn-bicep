@description('Name of Azure Function.')
param name string

@description('The location where this resource will reside')
param location string = resourceGroup().location

@allowed([
  'Y1'
  'B1'
])
param sku string

@allowed([
  'Dynamic'
  'Basic'
])
param tier string

@allowed([
  'app'
  'functionapp'
])
param kind string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: name
  location: location
  sku: {
    name: sku
    tier: tier
  }
  kind: kind
  properties: {
    reserved: kind == 'linux' ? true : false
  }
}

output appServicePlanId string = appServicePlan.id
