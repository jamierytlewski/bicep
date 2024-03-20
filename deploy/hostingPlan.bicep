@secure()
param appServicePlanName string

param location string
@secure()
param sku object

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  sku: sku
}
