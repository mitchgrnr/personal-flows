@description('Location of the resource group, resources are deployed here')
param location string
@description('Retrieved name of the deployment resource group')
param resourceGroupName string
@description('Generated Id of the azure subscription')
param subscriptionId string
param connections_todoconsumer_name string = 'todoconsumer'
resource connections_todoconsumer_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_todoconsumer_name
  location: location
  kind: 'V1'
  properties: {
    displayName: 'Microsoft To-Do (Consumer)'
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {}
    nonSecretParameterValues: {}
    api: {
      name: connections_todoconsumer_name
      displayName: 'Microsoft To-Do (Consumer)'
      description: 'Microsoft To-Do is an intelligent task management app that makes it easy to plan and manage your day. Connect to Microsoft To-Do to manage your tasks from various services. You can perform actions such as creating tasks.'
      iconUri: 'https://conn-afd-prod-endpoint-bmc9bqahasf3grgk.b01.azurefd.net/releases/v1.0.1690/1.0.1690.3719/${connections_todoconsumer_name}/icon.png'
      brandColor: '#185ABD'
      id: subscriptionResourceId('Microsoft.Web/locations/managedApis',location,connections_todoconsumer_name)
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://management.azure.com:443/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Web/connections/${connections_todoconsumer_name}/extensions/proxy/lists?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}
output connectionId string = connections_todoconsumer_name_resource.id
output connectionName string = connections_todoconsumer_name_resource.name
