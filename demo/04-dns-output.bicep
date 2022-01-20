
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: 'bicep.shawinnes.com'
}

output NameServers array = dnsZone.properties.nameServers
