resource dnsZoneDemo 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'bicepdemo.com'
  location: 'global'
}

output DemoNameServers array = dnsZoneDemo.properties.nameServers
