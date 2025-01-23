@description('Auto-generated build id used in deployment names')
param buildId int
@description('Location of the resource group, resources are deployed here')
param location string = resourceGroup().location
@description('Retrieved name of the deployment resource group')
param resourceGroupName string = resourceGroup().name
@description('Generated Id of the azure subscription')
param subscriptionId string = subscription().id
@description('Switch to disabled to turn off flows')
@allowed([
  'Enabled'
  'Disabled'
])
param flowState string = 'Enabled'

module connections 'connections.bicep' = {
  name: 'personalFlowsConnections_${buildId}'
  params: {
    location: location
    resourceGroupName: resourceGroupName
    subscriptionId: subscriptionId
  }
}

module blueFilterReplacement 'la_RecurringTask.bicep' = {
  name: 'replaceBlueFilter_${buildId}'
  params: {
    logicAppName: 'la_ReplaceBlueWaterFilter'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates bi-monthly blue water filter change task'
    startTime: '2025-01-14T02:40'
    frequency: 'Month'
    interval: 2
    hoursToTaskDue: 48
    hoursToReminder: 24
    taskTitle: 'Change Brita Tank Filter - Blue'
  }
}

module greenFilterReplacement 'la_RecurringTask.bicep' = {
  name: 'replaceGreenFilter_${buildId}'
  params: {
    logicAppName: 'la_ReplaceGreenWaterFilter'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates bi-monthly green water filter change task'
    startTime: '2025-01-14T02:40'
    frequency: 'Month'
    interval: 2
    hoursToTaskDue: 48
    hoursToReminder: 24
    taskTitle: 'Change Brita Pitcher Filter - Green'
  }
}

module pinkFilterReplacement 'la_RecurringTask.bicep' = {
  name: 'replacePinkFilter_${buildId}'
  params: {
    logicAppName: 'la_ReplacePinkWaterFilter'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates bi-monthly pink water filter change task'
    startTime: '2025-01-14T02:40'
    frequency: 'Month'
    interval: 2
    hoursToTaskDue: 48
    hoursToReminder: 24
    taskTitle: 'Change Brita Pitcher Filter - Pink'
  }
}
