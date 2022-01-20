targetScope = 'subscription'

param name string
param location string

param customer string
param application string
param environment string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location

  tags: {
    'Customer': customer
    'Application': application
    'Environment': environment
  }
}
