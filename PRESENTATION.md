---
marp: true
title: Intro to Bicep
author: Shaw Innes
---

# Azure Bicep

---


# Intro

- Background
- Alternatives – ARM, PowerShell, az-cli, Terraform
- Resources
- Demo
- Challenges – FW rules to access DB etc
- Summary

---

# What is Bicep?

@startuml
Bob -> Alice : hello
@enduml

---

# Comparison to other tools

## az-cli / Powershell

## ARM

Complex, Limited

## Terraform

Stateful, Idempontent, Providers, Provider Support


---

# Scopes

- Tenant
- Subscription
- Management Group
- Resource Group

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
  name: 'bicepdemo.com'
  location: 'global'
}
```

---

# Outputs

```
resource dnsZoneDemo 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'bicepdemo.com'
  location: 'global'
}

output DemoNameServers array = dnsZoneDemo.properties.nameServers
```

---


# Existing Resources 

```
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: 'shawinnes.com'
}

```

---

# What-If 

---

# Create

## Mode 

Complete

Incremental

---

# Demo 

* VS Code Plugins
* Resource Groups
* Resources

--- 

# Links

https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview

