
@description('Name of Azure App Service')
param appServiceNme string = 'bicepdemoapp'

@description('Name of Azure App Service Plan')
param appServicePlanNme string = 'bicepdemoplan'

@description('Name of Sql Server')
param sqlServerName string = 'bicepdemo'

@description('The location where this resource will reside')
param location string = resourceGroup().location

param aadGroupName string
param aadGroupId string
param clientIpAddress string

resource sqlServer 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: sqlServerName
  location: location
  
  identity: {
     type: 'SystemAssigned'
  }

  properties: {
    version: '12.0'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'    
    administrators: {
      login: aadGroupName
      sid: aadGroupId
      tenantId: subscription().tenantId
      principalType: 'Group'
      azureADOnlyAuthentication: true      
    }
  }

  resource sqlServerDatabase 'databases' = {
    name: 'sample'
    location: location
    properties: {
      requestedBackupStorageRedundancy: 'Local'
    }
  }

  resource sqlServerFirewall 'firewallRules' = {
    name: 'client-ip-default'
    properties: {
      startIpAddress: clientIpAddress
      endIpAddress: clientIpAddress
    }
  }

  resource sqlServerFirewallAzure 'firewallRules' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '0.0.0.0'
      }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanNme
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'Windows'
  properties: {    
    
  }
}

resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceNme
  location: location
  kind: 'app'
  
  identity: {
    type: 'SystemAssigned'
  }
  
  properties: {
    enabled: true
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      localMySqlEnabled: false
      ftpsState: 'Disabled'
      netFrameworkVersion: 'v6.0'
      windowsFxVersion: 'DOTNET|6.0'
      http20Enabled: true
    }
  }
}

output AppServiceEndpoint string = appService.properties.defaultHostName
output AppServicePrincipalId string = appService.identity.principalId
output AppServiceTenantId string = appService.identity.tenantId
output AppServiceIpRange string = appService.properties.outboundIpAddresses
output SqlServerEndpoint string = sqlServer.properties.fullyQualifiedDomainName
