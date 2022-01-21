
```
AADGROUP=`az ad group create --display-name bicep-demo-admin --mail-nickname bicep-demo-admin`
AADGROUPID=`echo $AADGROUP | jq -r .objectId`
AADGROUPNAME=`echo $AADGROUP | jq -r .displayName`

AADUSER=`az ad signed-in-user show`
AADUSERID=`echo $AADUSER | jq -r .objectId`

CLIENTIP=`curl ipconfig.sh`

# Add Admin User to Admin Group
az ad group member add --group $AADGROUPID --member-id $AADUSERID

az deployment group what-if --mode Incremental --name sqldemo --resource-group bicep-demo --template-file sqlserver.bicep --parameters aadGroupName="$AADGROUPNAME" aadGroupId="$AADGROUPID" clientIpAddress="$CLIENTIP"

DEPLOYMENT=`az deployment group create --mode Incremental --name sqldemo --resource-group bicep-demo --template-file sqlserver.bicep --parameters aadGroupName="$AADGROUPNAME" aadGroupId="$AADGROUPID" clientIpAddress="$CLIENTIP"`

echo $DEPLOYMENT| jq -r .properties.outputs

```

# Demo App


Requires: Microsoft.Data.SqlClient 3.0.0+

> System.ArgumentException: Invalid value for key 'authentication'.

this error indicates that the above library hasn't been installed

Usage: https://docs.microsoft.com/en-us/sql/connect/ado-net/sql/azure-active-directory-authentication?view=sql-server-ver15#setting-azure-active-directory-authentication

```bash
dotnet add package Microsoft.Data.SqlClient
```

## Development Configuration
```json
"ConnectionStrings": {
  "BloggingContext": "Server=bicepdemo.database.windows.net,1433;Database=sample;Authentication=Active Directory Default"
}
```

## Production Configuration
```json
"ConnectionStrings": {
  "BloggingContext": "Server=bicepdemo.database.windows.net,1433;Database=sample;Authentication=Active Directory Managed Identity"
}
```

# Create an EF Bundle

```bash
dotnet ef migrations bundle
```

Run from local development environment 

```bash
./efbundle --connection "Server=bicepdemo.database.windows.net,1433;Database=sample;Authentication=Active Directory Default"
```

```bash
pushd demoapp

rm -rf publish
dotnet publish --configuration Release --output publish

pushd publish

zip -r publish.zip ./*
popd

az webapp deploy --resource-group bicep-demo --name bicepdemoapp --src-path publish/publish.zip --type zip

popd
```

```sql
CREATE USER [bicepdemoapp] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [bicepdemoapp];
ALTER ROLE db_datawriter ADD MEMBER [bicepdemoapp];
ALTER ROLE db_ddladmin ADD MEMBER [bicepdemoapp];
```