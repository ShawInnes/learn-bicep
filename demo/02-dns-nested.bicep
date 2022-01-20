
resource dnsZoneDemo 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'bicep.shawinnes.com'
  location: 'global'

  resource dnsARecord 'A' = {
    name: '@'
    properties: {
      TTL: 3600
      ARecords: [
        {
          ipv4Address: '127.0.0.1'
        }
      ]
    }
  }
}
