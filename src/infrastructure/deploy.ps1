$region = 'germanywestcentral'

Get-Content ./students.csv | ConvertFrom-Csv | ForEach-Object {
    
    $storageAccountName = '{0}0fredapi0dev0stac' -f $_.short
    $functionappname = '{0}-fredapi-func-dev' -f $_.short
    $functionAppPlanName = '{0}-fredapi-asp-dev' -f $_.short
    $resourceGroupName = 'rg-{0}-fredapi-dev' -f $_.short

    # Create a resource group.
    az group create --name $resourceGroupName --location $region
    
    # Assign contributor right for the student
    az role assignment create --assignee $_.id --role "Contributor" --resource-group $resourceGroupName

    # Create an Azure storage account in the resource group.
    az storage account create --name $storageAccountName --location $region --resource-group $resourceGroupName --sku Standard_LRS

    # Create an appservice plan
    az appservice plan create --name $functionAppPlanName --resource-group $resourceGroupName --location $region --sku B1

    # Create a function app in the resource group.
    az functionapp create `
        --name $functionAppName `
        --plan $functionAppPlanName `
        --storage-account $storageAccountName `
        --resource-group $resourceGroupName `
        --disable-app-insights `
        --functions-version 3
}