
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
          value: 'node'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '14.17.0'
        }
      ]
    }
  }
}
