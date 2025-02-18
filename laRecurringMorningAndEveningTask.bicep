@description('The name of the logic app to create.')
param logicAppName string
@description('Location of the resource group, resources are deployed here')
param location string
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
@description('Base name of task to schedule in morning and evening')
param taskName string
@description('The evening time to delay the second task until')
param eveningTime int
@description('The hours from run and delay until task is due')
param dueTime int
@description('The time from run and delay that a reminder will send')
param remindTime int
@description('The task description to listen for')
param waitForTask string

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
        WhenRecurringTaskIsUpdated: {
          recurrence: {
            interval: 1
            frequency: 'Minute'
          }
          splitOn: '@triggerBody()'
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'todoconsumer\'][\'connectionId\']'
              }
            }
            method: 'get'
            path: '/trigger/onUpdateToDoInFolder/@{encodeURIComponent(\'AQMkADAwATMwMAItYjc3ADItMzMANjktMDACLTAwCgAuAAADQPd8gnkgGkqxpLHWo7bDjgEAb36bwlZLNU6EdSu91xXKmAAIbV4AQQAAAA==\')}'
          }
        }
      }
      actions: {
        Condition: {
          actions: {
            AddRecurringMorningTask: {
              type: 'ApiConnection'
              inputs: {
                host: {
                  connection: {
                    name: '@parameters(\'$connections\')[\'todoconsumer\'][\'connectionId\']'
                  }
                }
                method: 'post'
                body: {
                  title: '${taskName} morning at @{convertTimezone(addHours(utcNow(),${dueTime}),\'UTC\',\'Central Standard Time\',\'hh:mmtt\')},  @{convertTimezone(utcNow(),\'UTC\',\'Central Standard Time\',\'MM-dd\')}'
                  dueDateTime: {
                    dateTime: '@convertTimeZone(addHours(utcNow(),${dueTime}),\'UTC\', \'Central Standard Time\',\'yyyy-MM-dd\')'
                    timeZone: 'UTC'
                  }
                  reminderDateTime: {
                    dateTime: '@addHours(utcNow(),${remindTime})'
                    timeZone: 'UTC'
                  }
                  importance: 'normal'
                  status: 'notStarted'
                  body: {
                    contentType: 'html'
                  }
                }
                path: '/lists/@{encodeURIComponent(\'AQMkADAwATMwMAItYjc3ADItMzMANjktMDACLTAwCgAuAAADQPd8gnkgGkqxpLHWo7bDjgEAb36bwlZLNU6EdSu91xXKmAAIbV4AQQAAAA==\')}/tasks'
              }
            }
            WaitUntil5PMToSchedule: {
              runAfter: {
                AddRecurringMorningTask: [
                  'Succeeded'
                ]
              }
              type: 'Wait'
              inputs: {
                until: {
                  timestamp: '@convertTimezone(string(concat(convertTimezone(utcNow(),\'UTC\',\'Central Standard Time\',\'yyyy-MM-dd\'),\'T${eveningTime}:00:00\')),\'Central Standard Time\',\'UTC\')'
                }
              }
            }
            AddRecurringEveningTask: {
              runAfter: {
                WaitUntil5PMToSchedule: [
                  'Succeeded'
                ]
              }
              type: 'ApiConnection'
              inputs: {
                host: {
                  connection: {
                    name: '@parameters(\'$connections\')[\'todoconsumer\'][\'connectionId\']'
                  }
                }
                method: 'post'
                body: {
                  title: '${taskName} evening at @{convertTimezone(addHours(utcNow(),${dueTime}),\'UTC\',\'Central Standard Time\',\'hh:mmtt\')},  @{convertTimezone(utcNow(),\'UTC\',\'Central Standard Time\',\'MM-dd\')}'
                  dueDateTime: {
                    dateTime: '@convertTimeZone(addHours(utcNow(),${dueTime}),\'UTC\', \'Central Standard Time\',\'yyyy-MM-dd\')'
                    timeZone: 'UTC'
                  }
                  reminderDateTime: {
                    dateTime: '@addHours(utcNow(),${remindTime})'
                    timeZone: 'UTC'
                  }
                  importance: 'normal'
                  status: 'notStarted'
                  body: {
                    contentType: 'html'
                  }
                }
                path: '/lists/@{encodeURIComponent(\'AQMkADAwATMwMAItYjc3ADItMzMANjktMDACLTAwCgAuAAADQPd8gnkgGkqxpLHWo7bDjgEAb36bwlZLNU6EdSu91xXKmAAIbV4AQQAAAA==\')}/tasks'
              }
            }
          }
          runAfter: {}
          else: {
            actions: {
              Terminate: {
                type: 'Terminate'
                inputs: {
                  runStatus: 'Succeeded'
                }
              }
            }
          }
          expression: {
            and: [
              {
                equals: [
                  '@triggerBody()?[\'status\']'
                  'completed'
                ]
              }
              {
                contains: [
                  '@triggerBody()?[\'title\']'
                  '${waitForTask}'
                ]
              }
            ]
          }
          type: 'If'
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          todoconsumer: {
            id: subscriptionResourceId('Microsoft.Web/locations/managedApis',location,connectionName)
            connectionId: connectionId
            connectionName: connectionName
          }
        }
      }
    }
  }
}
