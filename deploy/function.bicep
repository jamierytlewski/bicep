
param functionAppName string
param location string
param appConfigurationId string

resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: toLower(functionAppName)
  location: location
  kind: 'functionapp'

  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
      http20Enabled: true
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource symbolicname 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: 'App Configuration Data Reader'
  properties: {
    roleDefinitionId: appConfigurationId
    principalId: functionApp.identity.principalId
  }
}
