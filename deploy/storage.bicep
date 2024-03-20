param storageLocation string
param storageName string

resource storageAcct 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: toLower(storageName)
  location: storageLocation
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
  properties: {
    minimumTlsVersion: 'TLS1_2'
  }
}
