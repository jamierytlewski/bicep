
param functionAppName string
param location string

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
