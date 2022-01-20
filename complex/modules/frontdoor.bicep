param frontDoorName string

resource frontDoor 'Microsoft.Network/frontdoors@2020-05-01' = {
  name: frontDoorName
  location: 'Global'
  properties: {
    enabledState: 'Enabled'

    frontendEndpoints: [
      {
        name: 'bicepdemoDemo-azurefd-net'
        properties: {
          hostName: '${frontDoorName}.azurefd.net'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 0
        }
      }
      {
        name: 'bicepdemo-Demo'
        properties: {
          hostName: 'bicepdemo.Demo'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 0
          webApplicationFirewallPolicyLink: {
            id: resourceId('bicepdemo-shared', 'Microsoft.Network/frontdoorwebapplicationfirewallpolicies', 'bicepdemo')
          }
        }
      }
    ]

    loadBalancingSettings: [
      {
        name: 'loadBalancingSettings-1630383146257'
        properties: {
          sampleSize: 4
          successfulSamplesRequired: 2
          additionalLatencyMilliseconds: 0
        }
      }
      {
        name: 'loadBalancingSettings-1630383182552'
        properties: {
          sampleSize: 4
          successfulSamplesRequired: 2
          additionalLatencyMilliseconds: 0
        }
      }
    ]

    healthProbeSettings: [
      {
        name: 'healthProbeSettings-1630383182552'
        properties: {
          path: '/'
          protocol: 'Https'
          intervalInSeconds: 30
          enabledState: 'Disabled'
          healthProbeMethod: 'HEAD'
        }
      }
      {
        name: 'healthProbeSettings-1630383146257'
        properties: {
          path: '/'
          protocol: 'Https'
          intervalInSeconds: 30
          enabledState: 'Disabled'
          healthProbeMethod: 'HEAD'
        }
      }
    ]

    backendPools: [
      {
        name: 'api'
        properties: {
          backends: [
            {
              address: 'bicepdemo-api-prod.azurewebsites.net'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              backendHostHeader: 'bicepdemo-api-prod.azurewebsites.net'
              enabledState: 'Enabled'
            }
          ]
          loadBalancingSettings: {
            id: resourceId('Microsoft.Network/frontDoors/loadBalancingSettings', frontDoorName, 'loadBalancingSettings-1630383182552')
          }
          healthProbeSettings: {
            id: resourceId('Microsoft.Network/frontDoors/healthProbeSettings', frontDoorName, 'healthProbeSettings-1630383182552')
          }
        }
      }
      {
        name: 'spa'
        properties: {
          backends: [
            {
              address: 'bicepdemo-prod.azurewebsites.net'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              backendHostHeader: 'bicepdemo-prod.azurewebsites.net'
              enabledState: 'Enabled'
            }
          ]
          loadBalancingSettings: {
            id: resourceId('Microsoft.Network/frontDoors/loadBalancingSettings', frontDoorName, 'loadBalancingSettings-1630383146257')
          }
          healthProbeSettings: {
            id: resourceId('Microsoft.Network/frontDoors/healthProbeSettings', frontDoorName, 'healthProbeSettings-1630383146257')
          }
        }
      }
    ]

    routingRules: [
      {
        name: 'spa'
        properties: {
          frontendEndpoints: [
            {
              id: resourceId('Microsoft.Network/frontDoors/frontEndEndpoints', frontDoorName, 'bicepdemo-Demo')
            }
          ]
          acceptedProtocols: [
            'Https'
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            forwardingProtocol: 'HttpsOnly'
            backendPool: {
              id: resourceId('Microsoft.Network/frontDoors/backEndPools', frontDoorName, 'spa')
            }
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
          }
          enabledState: 'Enabled'
        }
      }
      {
        name: 'api'
        properties: {
          frontendEndpoints: [
            {
              id: resourceId('Microsoft.Network/frontDoors/frontEndEndpoints', frontDoorName, 'bicepdemo-Demo')
            }
          ]
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          patternsToMatch: [
            '/api/*'
            '/files'
            '/files/*'
            '/video-proxy'
            '/video-proxy/*'
          ]
          routeConfiguration: {
            forwardingProtocol: 'HttpsOnly'
            backendPool: {
              id: resourceId('Microsoft.Network/frontDoors/backEndPools', frontDoorName, 'api')
            }
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
          }
          enabledState: 'Enabled'
        }
      }
      {
        name: 'httpsredirect'
        properties: {
          routeConfiguration: {
            redirectType: 'PermanentRedirect'
            redirectProtocol: 'HttpsOnly'
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorRedirectConfiguration'
          }
          frontendEndpoints: [
            {
              id: resourceId('Microsoft.Network/frontDoors/frontEndEndpoints', frontDoorName, 'bicepdemo-Demo')
            }
          ]
          acceptedProtocols: [
            'Http'
          ]
          patternsToMatch: [
            '/*'
          ]
          enabledState: 'Enabled'
        }
      }
    ]
  }
}

output frontDoorId string = frontDoor.id
