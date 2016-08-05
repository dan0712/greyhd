'use strict'

InvitesResourceFactory = ($resource) ->
  $resource('/api/v1/invites/:token.json', token: '@token',
    accept:
      method: 'GET'
  )

angular
  .module('greyhd')
  .factory('InvitesResource', ['$resource', InvitesResourceFactory])
