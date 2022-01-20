
# Deploying

```bash
az group create --name bicep-test-rg --location "Australia East"
az deployment group create -f ./main.bicep -g bicep-test-rg
```

# Get Deployment Token

```bash

az staticwebapp secrets list -g bicep-test-rg -n spa-app

az rest --method post --url /subscriptions/$AZURE_SUBSCRIPTION_ID/resourcegroups/bicep-test-rg/providers/Microsoft.Web/staticSites/spa-app/listsecrets?api-version=2020-06-01 --output json | jq -r .properties.apiKey

```

# Deploy Policy to Management Group

```bash

az deployment mg create --location australiaeast --management-group-id default-mg --template-file policy.bicep
az deployment sub create --location australiaeast --template-file tag-policy.bicep --verbose  

```


```
az deployment sub what-if --name bicepdemo --location AustraliaEast --template-file main.bicep
az deployment sub create --name bicepdemo --location AustraliaEast --template-file main.bicep
```
