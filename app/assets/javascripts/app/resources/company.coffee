'use strict'

CompanyResourceFactory = ($resource) ->
  $resource('/api/v1/companies/:action.json', {},
    current:
      params:
        action: 'current'
  )

angular
  .module('greyhd')
  .factory('CompanyResource', ['$resource', CompanyResourceFactory])
