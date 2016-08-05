'use strict'

AdminWorkstreamResourceFactory = ($resource) ->
  addConnectedToTasks = (response) ->
    workstreams = angular.fromJson(response)
    workstreams.map (workstream) ->
      workstream.tasks = workstream.tasks.map (task) ->
        task.connected = !!task.task_user_connection
        task
      workstream

  $resource('/api/v1/admin/workstreams/:id.json', { id: '@id' },
    connected:
      method: 'GET'
      url: '/api/v1/admin/users/:user_id/workstreams/connected.json'
      transformResponse: [addConnectedToTasks]
      isArray: true
      params:
        user_id: '@user_id'
  )

angular
  .module('greyhd')
  .factory('AdminWorkstreamResource', ['$resource', AdminWorkstreamResourceFactory])
