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
param flowState string = 'Disabled'

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
    flowState: 'Enabled'
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
    flowState: 'Enabled'
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
    flowState: 'Enabled'
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

module petFleaMeds 'la_RecurringTask.bicep' = {
  name: 'petFleaMeds_${buildId}'
  params: {
    logicAppName: 'la_GivePetFleaMeds'
    location: location
    flowState: 'Enabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates monthly apply pet flea meds task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Month'
    interval: 1
    hoursToTaskDue: 12
    hoursToReminder: 8
    taskTitle: 'Give pets flea meds'
  }
}
module letDogOutMorning 'la_RecurringScheduledTask.bicep' = {
  name: 'letDogOutMorning_${buildId}'
  params: {
    logicAppName: 'la_LetDogOutMorning'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily let dog out in the morning task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 4
    hoursToReminder: 2
    taskTitle: 'Let Dog Out - Morning'
    runHour: '6'
  }
}

module letDogOutEvening 'la_RecurringScheduledTask.bicep' = {
  name: 'letDogOutEvening_${buildId}'
  params: {
    logicAppName: 'la_LetDogOutEvening'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily let dog out in the evening task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 4
    hoursToReminder: 2
    taskTitle: 'Let Dog Out - Evening'
    runHour: '19'
  }
}

module giveDogPill 'la_RecurringScheduledTask.bicep' = {
  name: 'giveDogPill_${buildId}'
  params: {
    logicAppName: 'la_giveDogPill'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily give dog denamarin task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 4
    hoursToReminder: 2
    taskTitle: 'Give dog Denamarin'
    runHour: '5'
  }
}

module feedCatBreakfast 'la_RecurringScheduledTask.bicep' = {
  name: 'feedCatBreakfast_${buildId}'
  params: {
    logicAppName: 'la_feedCatBreakfast'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily feed cat breakfast task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 4
    hoursToReminder: 2
    taskTitle: 'Feed cat breakfast'
    runHour: '5'
  }
}

module feedCatDinner 'la_RecurringScheduledTask.bicep' = {
  name: 'feedCatDinner_${buildId}'
  params: {
    logicAppName: 'la_feedCatDinner'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily feed cat dinner task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 4
    hoursToReminder: 2
    taskTitle: 'Feed cat dinner'
    runHour: '16'
  }
}

module dailyDogFeeding 'laRecurringMorningAndEveningTask.bicep' = {
  name: 'dailyDogFeeding_${buildId}'
  params: {
    logicAppName: 'la_dailyDogFeeding'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily dog feeding tasks'
    dueTime: 1
    eveningTime: 17
    remindTime: 1
    taskName: 'Feed dog'
    waitForTask: 'Give dog Denamarin'
  }
}

module dilationOne 'la_RecurringScheduledTask.bicep' = {
  name: 'dilationOne_${buildId}'
  params: {
    logicAppName: 'la_dilationOne'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates frist daily dilation task'
    startTime: '2024-02-03T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 2
    hoursToReminder: 1
    taskTitle: 'Dilation 1'
    runHour: '5'
  }
}

module dilationTwo 'la_RecurringScheduledTask.bicep' = {
  name: 'dilationTwo_${buildId}'
  params: {
    logicAppName: 'la_dilationTwo'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily second dilation task'
    startTime: '2024-02-03T00:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 2
    hoursToReminder: 1
    taskTitle: 'Feed cat dinner'
    runHour: '11'
  }
}
module dilationThree 'la_RecurringScheduledTask.bicep' = {
  name: 'dilationThree_${buildId}'
  params: {
    logicAppName: 'la_diltionThree'
    location: location
    flowState: flowState
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily third dilation task'
    startTime: '2024-02-03T00:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 2
    hoursToReminder: 1
    taskTitle: 'Dilation 3'
    runHour: '17'
  }
}
