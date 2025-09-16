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
    flowState: 'Disabled'
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
//Green pitcher is gone, only here for posterity
module greenFilterReplacement 'la_RecurringTask.bicep' = {
  name: 'replaceGreenFilter_${buildId}'
  params: {
    logicAppName: 'la_ReplaceGreenWaterFilter'
    location: location
    flowState: 'Disabled'
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
    flowState: 'Disabled'
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

module trtShot 'la_RecurringTask.bicep' = {
  name: 'trtShot_${buildId}'
  params: {
    logicAppName: 'la_trtShot'
    location: location
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates weekly TRT Shot Item'
    startTime: '2025-06-11T05:00'
    frequency: 'Week'
    interval: 1
    hoursToTaskDue: 12
    hoursToReminder: 6
    taskTitle: 'Testosterone Shot'
  }
}
module hizentraInfustion 'la_RecurringTask.bicep' = {
  name: 'hizentraInfusion_${buildId}'
  params: {
    logicAppName: 'la_hizentraInfusion'
    location: location
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates weekly item for Hizentra home infustion'
    startTime: '2025-06-11T05:00'
    frequency: 'Week'
    interval: 1
    hoursToTaskDue: 5
    hoursToReminder: 3
    taskTitle: 'Immunoglobulin Home Infusion'
  }
}
module takeTrashOut 'la_RecurringTask.bicep' = {
  name: 'takeTrashOut_${buildId}'
  params: {
    logicAppName: 'la_takeTrashOut'
    location: location
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates weekly item for taking trash out'
    startTime: '2025-06-12T05:00'
    frequency: 'Week'
    interval: 1
    hoursToTaskDue: 14
    hoursToReminder: 8
    taskTitle: 'Take trash out and cans to curb'
  }
}
module putHelloFreshAway 'la_RecurringTask.bicep' = {
  name: 'putHelloFreshAway_${buildId}'
  params: {
    logicAppName: 'la_putHelloFreshAway'
    location: location
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates weekly item to put away Hello Fresh box'
    startTime: '2025-06-13T05:00'
    frequency: 'Week'
    interval: 1
    hoursToTaskDue: 14
    hoursToReminder: 10
    taskTitle: 'Put away contents of Hello Fresh box'
  }
}
module laminateRecipeCards 'la_RecurringTask.bicep' = {
  name: 'laminateRecipeCards_${buildId}'
  params: {
    logicAppName: 'la_laminateRecipeCards'
    location: location
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates weekly item for laminating and sorting recipe kit cards'
    startTime: '2025-06-13T05:00'
    frequency: 'Week'
    interval: 1
    hoursToTaskDue: 14
    hoursToReminder: 10
    taskTitle: 'Laminate recipe kit cards and plan meals for the week'
  }
}

module petFleaMeds 'la_RecurringTask.bicep' = {
  name: 'petFleaMeds_${buildId}'
  params: {
    logicAppName: 'la_GivePetFleaMeds'
    location: location
    flowState: 'Disabled'
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
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily let dog out in the morning task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 4
    hoursToReminder: 1
    taskTitle: 'Let Dog Out - Morning'
    runHour: '5'
  }
}

module letDogOutEvening 'la_RecurringScheduledTask.bicep' = {
  name: 'letDogOutEvening_${buildId}'
  params: {
    logicAppName: 'la_LetDogOutEvening'
    location: location
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily let dog out in the evening task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 4
    hoursToReminder: 1
    taskTitle: 'Let Dog Out - Evening'
    runHour: '18'
  }
}

module giveDogPill 'la_RecurringScheduledTask.bicep' = {
  name: 'giveDogPill_${buildId}'
  params: {
    logicAppName: 'la_giveDogPill'
    location: location
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily give dog denamarin task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 3
    hoursToReminder: 1
    taskTitle: 'Give dog Denamarin'
    runHour: '5'
  }
}

module feedCatBreakfast 'la_RecurringScheduledTask.bicep' = {
  name: 'feedCatBreakfast_${buildId}'
  params: {
    logicAppName: 'la_feedCatBreakfast'
    location: location
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily feed cat breakfast task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 2
    hoursToReminder: 1
    taskTitle: 'Feed cat breakfast'
    runHour: '5'
  }
}

module feedCatDinner 'la_RecurringScheduledTask.bicep' = {
  name: 'feedCatDinner_${buildId}'
  params: {
    logicAppName: 'la_feedCatDinner'
    location: location
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily feed cat dinner task'
    startTime: '2024-12-27T12:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 2
    hoursToReminder: 1
    taskTitle: 'Feed cat dinner'
    runHour: '16'
  }
}

module dailyDogFeeding 'laRecurringMorningAndEveningTask.bicep' = {
  name: 'dailyDogFeeding_${buildId}'
  params: {
    logicAppName: 'la_dailyDogFeeding'
    location: location
    flowState: 'Disabled'
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
    flowState: 'Disabled'
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
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily second dilation task'
    startTime: '2024-02-03T00:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 2
    hoursToReminder: 1
    taskTitle: 'Dilation 2'
    runHour: '14'
  }
}
module dilationThree 'la_RecurringScheduledTask.bicep' = {
  name: 'dilationThree_${buildId}'
  params: {
    logicAppName: 'la_diltionThree'
    location: location
    flowState: 'Disabled'
    connectionId: connections.outputs.connectionId
    connectionName: connections.outputs.connectionName
    purposeTag: 'Creates daily third dilation task'
    startTime: '2024-02-03T00:00:00.000Z'
    frequency: 'Day'
    interval: 1
    hoursToTaskDue: 2
    hoursToReminder: 1
    taskTitle: 'Dilation 3'
    runHour: '16'
  }
}
