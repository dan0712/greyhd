'use strict'

AdminTaskUserConnectionResourceFactory = ($resource) ->
  $resource('/api/v1/admin/task_user_connections/:id.json', { id: '@id' },
    assign:
      url: '/api/v1/admin/users/:user_id/task_user_connections/assign.json'
      method: 'POST'
      params:
        user_id: '@user_id'
  )

angular
  .module('greyhd')
  .factory('AdminTaskUserConnectionResource', [
    '$resource',
    AdminTaskUserConnectionResourceFactory
  ])
