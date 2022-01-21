

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
