'use strict'

AdminTaskResourceFactory = ($resource) ->
  $resource('/api/v1/admin/tasks/:id.json', { id: '@id' },
    query:
      url: '/api/v1/admin/workstreams/:workstream_id/tasks.json'
      isArray: true
      params:
        workstream_id: '@workstream_id'
    create:
      url: '/api/v1/admin/workstreams/:workstream_id/tasks.json'
      method: 'POST'
      params:
        workstream_id: '@workstream_id'
  )

angular
  .module('greyhd')
  .factory('AdminTaskResource', ['$resource', AdminTaskResourceFactory])
