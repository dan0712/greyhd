'use strict'

AdminLocationResourceFactory = ($resource) ->
  $resource('/api/v1/admin/locations/:id.json', id: '@id')

angular
  .module('greyhd')
  .factory('AdminLocationResource', ['$resource', AdminLocationResourceFactory])
