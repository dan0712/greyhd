'use strict'

AdminTeamResourceFactory = ($resource) ->
  $resource('/api/v1/admin/teams/:id.json', id: '@id')

angular
  .module('greyhd')
  .factory('AdminTeamResource', ['$resource', AdminTeamResourceFactory])
