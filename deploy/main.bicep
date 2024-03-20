targetScope = 'subscription'

@description('Select the type of environment you want to provision. Allowed values are Production and Test.')
@allowed([
  'Production'
  'Test'
])
param environmentType string
param resourceGroupName string
param resourceGroupLocation string

resource newRG 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-${resourceGroupName}-${environmentType}'
  location: resourceGroupLocation
}

module storageAcct 'storage.bicep' = {
  name: 'storageModule'
  scope: newRG
  params: {
    storageLocation: newRG.location
    storageName: 'stor${resourceGroupName}${environmentType}'
  }
}

module hostingPlan 'hostingPlan.bicep' = {
  name: 'hostingPlanModule'
  scope: newRG
  params: {
    appServicePlanName: 'asp-${resourceGroupName}-fn-${environmentType}'
    location: newRG.location
    sku: {
      name: 'Y1'
      capacity: 1
    }
  }
}

module functionApp 'function.bicep' = {
  name: 'functionAppModule'
  scope: newRG
  params: {
    location: newRG.location
    functionAppName: 'fn-${resourceGroupName}-${environmentType}'
  }
}

// module appConfiguration 'appconfiguration.bicep' = {
//   name: 'appConfigurationModule'
//   scope: newRG
//   params: {
//     appConfigurationName: 'appconfig-${resourceGroupName}-${environmentType}'
//     location: newRG.location
//   }
// }

// @description('The location into which your Azure resources should be deployed.')
// param location string = resourceGroup().location



// @description('A unique suffix to add to resource names that need to be globally unique.')
// @maxLength(13)
// param resourceNameSuffix string = uniqueString(resourceGroup().id)

// // Define the names for resources.
// var appServiceAppName = 'toy-website-${resourceNameSuffix}'
// var appServicePlanName = 'toy-website'
// var logAnalyticsWorkspaceName = 'workspace-${resourceNameSuffix}'
// var applicationInsightsName = 'toywebsite'
// var storageAccountName = 'mystorage${resourceNameSuffix}'

// Define the SKUs for each component based on the environment type.


// resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
//   name: appServiceAppName
//   location: location
//   properties: {
//     serverFarmId: appServicePlan.id
//     httpsOnly: true
//     siteConfig: {
//       appSettings: [
//         {
//           name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
//           value: applicationInsights.properties.InstrumentationKey
//         }
//         {
//           name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
//           value: applicationInsights.properties.ConnectionString
//         }
//       ]
//     }
//   }
// }

// resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
//   name: logAnalyticsWorkspaceName
//   location: location
// }

// resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
//   name: applicationInsightsName
//   location: location
//   kind: 'web'
//   properties: {
//     Application_Type: 'web'
//     Request_Source: 'rest'
//     Flow_Type: 'Bluefield'
//     WorkspaceResourceId: logAnalyticsWorkspace.id
//   }
// }

// resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
//   name: storageAccountName
//   location: location
//   kind: 'StorageV2'
//   sku: environmentConfigurationMap[environmentType].storageAccount.sku
// }

// output appServiceAppHostName string = appServiceApp.properties.defaultHostName
