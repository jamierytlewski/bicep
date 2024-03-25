targetScope = 'subscription'

@description('Select the type of environment you want to provision. Allowed values are Production and Test.')
@allowed([
  'Production'
  'Test'
])
param environmentType string
param resourceGroupName string
param resourceGroupLocation string = 'eastus'

resource newRG 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: toLower('rg-${resourceGroupName}-${environmentType}')
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

module appConfiguration 'appconfiguration.bicep' = {
  name: 'appConfigurationModule'
  scope: newRG
  params: {
    appConfigurationName: 'appc-${resourceGroupName}-${environmentType}'
    location: newRG.location
  }
}

module functionApp 'function.bicep' = {
  name: 'functionAppModule'
  scope: newRG
  params: {
    location: newRG.location
    functionAppName: 'fn-${resourceGroupName}-${environmentType}'
    appConfigurationId: appConfiguration.outputs.appConfigurationId
  }
}


