@description('The name of the logic app to create.')
param logicAppName string
@description('Location of the resource group, resources are deployed here')
param location string
@description('Retrieved name of the deployment resource group')
param resourceGroupName string
@description('Generated Id of the azure subscription')
param subscriptionId string
@description('Switch to disabled to turn off flows')
@allowed([
  'Enabled'
  'Disabled'
])
param flowState string = 'Enabled'
@description('Name of To Do Consumer connection in same resource group')
param connectionName string
@description('Id of To Do consumer connection in same resource group')
param connectionId string
@description('Informational purpose tag to add to resource')
param purposeTag string
@description('The frequency interval of the recurrence')
@allowed([
  'Second'
  'Minute'
  'Hour'
  'Day'
  'Week'
  'Month'
])
param frequency string
@description('Whole number integer of frequency periods between recurrences')
param interval int
@description('When the schedule of recurrences should start')
param startTime string
@description('Integer number of hours to when due date should be set')
param hoursToTaskDue int
@description('Integer number of hours until a reminder is scheduled')
param hoursToReminder int
@description('Text to desribe the needed task, timestamp will be added after')
param taskTitle string

var actionType = 'http'
var method = 'GET'
var workflowSchema = 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'

resource logicApp 'Microsoft.Logic/workflows@2017-07-01' = {
  name: logicAppName
  location: location
  tags: {
    purpose: purposeTag
  }
  properties: {
    state: flowState
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        '${interval}_${frequency}(s)': {
          recurrence: {
            interval: interval
            frequency: frequency
            startTime: startTime
            timeZone: 'Central Standard Time'
          }
          type: 'Recurrence'
        }
      }
      actions: {
        Add_recurring_item: {
          runAfter: {}
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: connectionName
              }
            }
            method: 'post'
            body: {
              title: '${taskTitle} @{convertTimezone(utcNow(),\'UTC\',\'Central Standard Time\',\'MM-dd\')}'
              dueDateTime: {
                dateTime: '@addHours(convertTimezone(utcNow(),\'UTC\',\'Central Standard Time\'),${hoursToTaskDue})'
                timeZone: 'UTC'
              }
              reminderDateTime: {
                dateTime: '@addHours(utcNow(),${hoursToReminder})'
                timeZone: 'UTC'
              }
              importance: 'normal'
              status: 'notStarted'
              body: {
                contentType: 'html'
              }
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          todoconsumer: {
            id: '/subscriptions/${subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/${connectionName}'
            connectionId: connectionId
            connectionName: connectionName
          }
        }
      }
    }
  }
}
