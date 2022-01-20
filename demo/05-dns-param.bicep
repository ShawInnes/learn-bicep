@description('Record Name')
@allowed([
  'blog'
  'www'
  'mail'
])
param record string

resource dnsZoneDemo 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'bicep.shawinnes.com'
  location: 'global'

  resource dnsARecord 'A' = {
    name: record
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
