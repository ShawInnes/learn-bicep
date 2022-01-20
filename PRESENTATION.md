---
marp: true
title: Intro to Bicep
author: Shaw Innes
paginate: true
footer: Intro to Bicep
theme: default
---

<style>
section {
  background: #000000;
  color: #cccccc;
}

section pre {
  background: #333333
}

h1,
h2,
h3 {
  color: #90C226
}

</style>

# <!-- fit --> Introduction to Bicep :muscle:

---

# Intro

- Background
- Other Tools
- Resources
- Demo
- Summary

---

# What is Bicep?

> Bicep is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources.

---

# Comparison to other tools

## Bicep 

Uses the Resource Manager API, As soon as a resource provider introduces new resources types and API versions, you can use them in your Bicep file

---

# Comparison to other tools

## az-cli / Powershell

:white_check_mark: Low barrier to entry
:x: Not Idempontent
:x: Terrible to source control
:x: az-cli is constantly changing

---

# Comparison to other tools

## ARM

:white_check_mark: Azure default tool
:x: Complex DSL
:x: Limited logic
:x: Horrible to version control & diff

---

# Comparison to other tools

## Terraform

:white_check_mark: Cleaner DSL than ARM
:interrobang: Stateful
:white_check_mark: Idempontent
:white_check_mark: Multiple Platform Providers
:x: Questionable Support, often lags for Azure

---

# Applying Changes

## What-If & Create 

### Modes

1. Complete
1. Incremental

---

# Basic Bicep Resource

```
resource dnsZoneDemo 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'shawinnes.com'
  location: 'global'
}
```

--- 

# Nested Resources

```
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
```

---

# Existing Resources 

```
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
```

---

# Outputs

```
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: 'bicep.shawinnes.com'
}

output NameServers array = dnsZoneDemo.properties.nameServers
```

---

# Parameters

```
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
```

---

# Loops

```
param servers object = {
  srv01: {
    name: 'srv01'
    address: '10.0.1.1'
    enabled: true
  }
  srv02: {
    name: 'srv02'
    address: '10.0.1.2'
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
```

---

# <!-- fit --> :muscle: DEMO

---

# Scopes

- Tenant
- Subscription
- Management Group
- Resource Group

--- 

# Links

* VS Code Plugins

https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview

