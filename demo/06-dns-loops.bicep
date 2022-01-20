
param servers object = {
  srv01: {
    name: 'srv01'
    address: '10.0.1.1'
    enabled: true
  }
  srv02: {
    name: 'srv02'
    address: '10.0.1.2'
    enabled: true
  }
  srv03: {
    name: 'srv03'
    address: '10.0.1.3'
    enabled: false
  }  
}

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: 'bicep.shawinnes.com'
}

resource dnsRecord 'Microsoft.Network/dnsZones/A@2018-05-01' = [for server in items(servers): if (server.value.enabled) {
  parent: dnsZone
  name: server.key // or server.value.name
  properties: {
    TTL: 3600
    ARecords: [
      {
        ipv4Address: server.value.address
      }
    ]
  }
}]
