'use strict'

AdminInvitesResourceFactory = ($resource) ->
  $resource('/api/v1/admin/invites/:id.json', id: '@id',
    create:
      url: '/api/v1/admin/users/:user_id/invites.json'
      method: 'POST'
      params:
        user_id: '@user_id'
  )

angular
  .module('greyhd')
  .factory('AdminInvitesResource', ['$resource', AdminInvitesResourceFactory])
