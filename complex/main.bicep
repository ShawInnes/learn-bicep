targetScope = 'subscription'

param defaultLocation string = 'Australia East'

param tagApplication string = 'bicepdemo'
param tagCustomer string = 'Bicep Demo'

param resourcePrefix string = 'bicepdemo'

param sqlAdminPassword string

var resourceGroupShared = '${resourcePrefix}-shared'
var resourceGroupProd = '${resourcePrefix}-prod'
var resourceGroupTest = '${resourcePrefix}-test'

module tagPolicy './modules/tag-policy.bicep' = {
  name: 'tagPolicy'
  params: {
    location: defaultLocation
    tagNames: [
      'Customer'
      'Application'
      'Environment'
    ]
  }
}

module sharedRg './modules/resource-group.bicep' = {
  name: 'resourceGroupShared'
  params: {
    name: resourceGroupShared
    environment: 'Shared'
    location: defaultLocation
    application: tagApplication
    customer: tagCustomer
  }
}

module TestRg './modules/resource-group.bicep' = {
  name: 'resourceGroupTest'
  params: {
    name: resourceGroupTest
    environment: 'Test'
    location: defaultLocation
    application: tagApplication
    customer: tagCustomer
  }
}

module prodRg './modules/resource-group.bicep' = {
  name: 'resourceGroupProd'
  params: {
    name: resourceGroupProd
    environment: 'Production'
    location: defaultLocation
    application: tagApplication
    customer: tagCustomer
  }
}

module dns './modules/dns.bicep' = {
  scope: resourceGroup(resourceGroupShared)
  name: 'dns'
}

module wafPolicy './modules/waf-policy.bicep' = {
  scope: resourceGroup(resourceGroupShared)
  name: 'wafPolicy'
  params: {
    resourcePrefix: resourcePrefix
  }
}

module frontDoor './modules/frontdoor.bicep' = {
  scope: resourceGroup(resourceGroupProd)
  name: 'frontDoor'
  params: {
    frontDoorName: '${resourcePrefix}prod'
  }
}

module frontDoorDns './modules/frontdoor-dns.bicep' = {
  scope: resourceGroup(resourceGroupShared)
  name: 'frontDoorDns'
  params: {
    frontDoorName: '${resourcePrefix}prod'
    defaultTTL: 60
    frontDoorId: frontDoor.outputs.frontDoorId
  }
}

module storageAccountProd './modules/storageaccount.bicep' = {
  scope: resourceGroup(resourceGroupProd)
  name: 'storageAccountProd'
  params: {
    name: '${resourcePrefix}prod'
  }
}

module storageAccountTest './modules/storageaccount.bicep' = {
  scope: resourceGroup(resourceGroupTest)
  name: 'storageAccountTest'
  params: {
    name: '${resourcePrefix}test'
  }
}

module appInsightsTest './modules/application-insights.bicep' = {
  scope: resourceGroup(resourceGroupTest)
  name: 'appInsightsTest'
  params: {
    name: '${resourcePrefix}-test'
  }
}

module mediaServices './modules/mediaservices.bicep' = {
  scope: resourceGroup(resourceGroupProd)
  name: 'mediaServices'
  params: {
    name: resourcePrefix
    storageAccountId: storageAccountProd.outputs.storageId
  }
}

module sqlServerTest './modules/sqlserver.bicep' = {
  scope: resourceGroup(resourceGroupTest)
  name: 'sqlServerTest'
  params: {
    name: '${resourcePrefix}-test'
    sqlAdminLogin: '${resourcePrefix}-test-admin'
    sqlAdminPassword: sqlAdminPassword
  }
}

module functionASPTest './modules/appserviceplan.bicep' = {
  scope: resourceGroup(resourceGroupTest)
  name: 'functionASPTest'
  params: {
    name: '${resourcePrefix}-functions-test'
    kind: 'functionapp'
    sku: 'Y1'
    tier: 'Dynamic'
  }
}

var functionAppConfig = []

module functionAppTest './modules/functionapp.bicep' = {
  scope: resourceGroup(resourceGroupTest)
  name: 'functionAppTest'
  params: {
    name: '${resourcePrefix}-functions-test'
    aiInstrumentationKey: appInsightsTest.outputs.aiInstrumentationkey
    appConfig: functionAppConfig
    appServicePlan: functionASPTest.outputs.appServicePlanId
  }
}

module apiASPTest './modules/appserviceplan.bicep' = {
  scope: resourceGroup(resourceGroupTest)
  name: 'apiASPTest'
  params: {
    name: '${resourcePrefix}-test'
    kind: 'app'
    sku: 'B1'
    tier: 'Basic'
  }
}

var appAppConfig = []

module appAppServiceTest './modules/appservice.bicep' = {
  scope: resourceGroup(resourceGroupTest)
  name: 'appAppServiceTest'
  params: {
    name: '${resourcePrefix}-test'
    aiInstrumentationKey: appInsightsTest.outputs.aiInstrumentationkey
    appConfig: appAppConfig
    appServicePlanId: apiASPTest.outputs.appServicePlanId
  }
}

var apiAppConfig = []

module apiAppServiceTest './modules/appservice.bicep' = {
  scope: resourceGroup(resourceGroupTest)
  name: 'apiAppServiceTest'
  params: {
    name: '${resourcePrefix}-test-api'
    aiInstrumentationKey: appInsightsTest.outputs.aiInstrumentationkey
    appConfig: apiAppConfig
    appServicePlanId: apiASPTest.outputs.appServicePlanId
  }
}

output DemoNameServers array = dns.outputs.DemoNameServers
