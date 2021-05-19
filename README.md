# GitHub Actions sample repository

## Instructions

- Fork the repository to your own GitHub account
- https://<INITALS>-fredapi-func-dev.azurewebsites.net/api/SayHello?name=<YOURNAME>

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/de-de/cli/azure/install-azure-cli?WT.mc_id=AZ-MVP-5003203)
- [Azure Function CLI](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=linux%2Ccsharp%2Cbash&WT.mc_id=AZ-MVP-5003203#install-the-azure-functions-core-tools)

## Scaffolding

This section contains information how we have created the sample.

### Azure Function project

- Create a local Functions project and select _dotnet_ for the worker runtime:

  ```bash
  func init FredApi
  ```

- Create a function with a _HTTP trigger_

  ```bash
  cd FredApi
  func new --name SayHello --template 'HTTP trigger'
  ```

### Azure infrastructure

The following script creates a resource group with a storage account and an azure function app

```powershell
    $initials = 'mbr'
    $storageAccountName = '{0}0fredapi0dev0stac' -f $initials
    $functionappname = '{0}-fredapi-func-dev' -f $initials
    $functionAppPlanName = '{0}-fredapi-asp-dev' -f $initials
    $resourceGroupName = 'rg-{0}-fredapi-dev' -f $initials

    # Create a resource group.
    az group create `
      --name $resourceGroupName `
      --location $region

    # Create an Azure storage account in the resource group.
    az storage account create `
      --name $storageAccountName `
      --location $region `
      --resource-group $resourceGroupName `
      --sku Standard_LRS

    # Create an appservice plan
    az appservice plan create `
      --name $functionAppPlanName `
      --resource-group $resourceGroupName `
      --location $region `
      --sku B1

    # Create a function app in the resource group.
    az functionapp create `
        --name $functionAppName `
        --plan $functionAppPlanName `
        --storage-account $storageAccountName `
        --resource-group $resourceGroupName `
        --disable-app-insights `
        --functions-version 3
```
