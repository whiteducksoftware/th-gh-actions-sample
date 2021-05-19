# GitHub Actions sample repository

## Instructions

- [Fork the repository](https://docs.github.com/en/github/getting-started-with-github/fork-a-repo) to your own GitHub account.
- Go to your Azure Function and [download your publish profile](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-github-actions?tabs=dotnet&WT.mc_id=AZ-MVP-5003203#download-your-publish-profile).
- [Add a GitHub secret](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-github-actions?tabs=dotnet&WT.mc_id=AZ-MVP-5003203#add-the-github-secret) using `PUBLISHSETTINGS` for the **Name** and the content of the publishing profile for the **Value**.
- In the `.github/workflows/fred-api-cicd.yml` workflow in Line 10, change the `INITIALS` environment variable to your initals and commit the changes to the **main** branch.
- Go to the **Actions** view and enable them by clicking the green "I understand my workflows, go ahead and enable them" button
- Select the `.github/workflows/fred-api-cicd.yml` workflow and run it using the `Run workflow` button. (See: [Running a workflow on GitHub](https://docs.github.com/en/actions/managing-workflow-runs/manually-running-a-workflow#running-a-workflow-on-github))
- After the workflow run you can test the deployment by calling the following URL: `https://<INITALS>-fredapi-func-dev.azurewebsites.net/api/SayHello?name=<YOURNAME>`

## Bonus: Scaffolding the function and infrastructure

This section contains information on how we have created the sample.

### Prerequisites

- [Azure CLI](https://docs.microsoft.com/de-de/cli/azure/install-azure-cli?WT.mc_id=AZ-MVP-5003203)
- [Azure Function CLI](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=linux%2Ccsharp%2Cbash&WT.mc_id=AZ-MVP-5003203#install-the-azure-functions-core-tools)

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
