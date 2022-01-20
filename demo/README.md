### Setup

```
az group create --location australiaeast --resource-group bicep-demo
```

### Demo 1 - Simple Resource

```
az deployment group what-if --mode Incremental --name demo01 --resource-group bicep-demo --template-file 01-dns.bicep

az deployment group create --mode Incremental --name demo01 --resource-group bicep-demo --template-file 01-dns.bicep
```

### Demo 2 - Nested Resource

```
az deployment group what-if --mode Incremental --name demo01 --resource-group bicep-demo --template-file 02-dns-nested.bicep

az deployment group create --mode Incremental --name demo01 --resource-group bicep-demo --template-file 02-dns-nested.bicep
```

### Demo 3 - Existing Resource

```
az deployment group what-if --mode Incremental --name demo01 --resource-group bicep-demo --template-file 03-dns-existing.bicep

az deployment group create --mode Incremental --name demo01 --resource-group bicep-demo --template-file 03-dns-existing.bicep
```

### Demo 4 - Outputs

```
az deployment group create --mode Incremental --name demo01 --resource-group bicep-demo --template-file 04-dns-output.bicep
```

### Demo 5 - Params

```
az deployment group create --mode Incremental --name demo01 --resource-group bicep-demo --template-file 05-dns-param.bicep --parameters record='test'

az deployment group create --mode Incremental --name demo01 --resource-group bicep-demo --template-file 05-dns-param.bicep --parameters record='blog'

az deployment group create --mode Incremental --name demo01 --resource-group bicep-demo --template-file 05-dns-param.bicep
```

### Demo 6 - Loops

```
az deployment group what-if --mode Incremental --name demo01 --resource-group bicep-demo --template-file 06-dns-loops.bicep
```

### Teardown

```
az group delete --resource-group bicep-demo
```