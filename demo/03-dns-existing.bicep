
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: 'bicep.shawinnes.com'
}

resource dnsRecord 'Microsoft.Network/dnsZones/A@2018-05-01' = {
  parent: dnsZone
  name: 'blog'
  properties: {
    TTL: 3600
    ARecords: [
      {
        ipv4Address: '127.0.0.1'
      }
    ]
  }
}
