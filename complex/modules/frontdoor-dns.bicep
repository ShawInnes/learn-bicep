param defaultTTL int = 60
param frontDoorName string
param frontDoorId string

resource dnsZoneDemo 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: 'bicepdemo.Demo'
}

resource dnsRecordDemoApex 'Microsoft.Network/dnsZones/A@2018-05-01' = {
  parent: dnsZoneDemo
  name: '@'
  properties: {
    TTL: defaultTTL
    targetResource: {
      id: frontDoorId
    }
  }
}

resource dnsRecordDemoAfdVerify 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  parent: dnsZoneDemo
  name: 'afdverify'
  properties: {
    TTL: defaultTTL
    CNAMERecord: {
      cname: 'afdverify.${frontDoorName}.azurefd.net'
    }
  }
}
