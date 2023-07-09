param name string
param location string = resourceGroup().location
param tags object = {}

param publisherEmail string
param publisherName string

//vnet itegration
param private bool = false
param apimsubnetId string
param publicIpAddressId string

@allowed([
  'Basic'
  'Consumption'
  'Developer'
  'Isolated'
  'Premium'
  'Standard'
])
param sku string = 'Consumption'


@allowed([
  0
  1
  2
])
param skuCount int = 0
// Default is 1, but must be 0 in case of Consumption SKU.

resource apiManagementService 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    capacity: skuCount
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    // vnet integration for access backend via private endpoint
    virtualNetworkType: ( private ) ? 'External' : 'None'
    virtualNetworkConfiguration: ( private ) ? {
        subnetResourceId: apimsubnetId 
    } : null
    publicIpAddressId: ( private ) ? publicIpAddressId : null
  }
}
