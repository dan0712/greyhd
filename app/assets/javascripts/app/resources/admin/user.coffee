'use strict'

AdminUserResourceFactory = ($resource) ->
  convertStartDateToString = (data) ->
    data = angular.copy(data)
    data.start_date = moment(data.start_date).format('DD-MM-YYYY') if data.start_date
    if data?.manager?.start_date
      data.manager.start_date = moment(data.manager.start_date).format('DD-MM-YYYY')
    angular.toJson(data)
  convertStartDateToObject = (data) ->
    data = angular.fromJson(data)
    data.start_date = moment(data.start_date).toDate() if (data.start_date)
    if data?.manager?.start_date
      data.manager.start_date = moment(data.manager.start_date).toDate()
    data

  $resource('/api/v1/admin/users/:id.json', { id: '@id' },
    update:
      method: 'PUT'
      transformResponse: [convertStartDateToObject]
      transformRequest: [convertStartDateToString]
    create:
      transformResponse: [convertStartDateToObject]
      transformRequest: [convertStartDateToString]
    get:
      transformResponse: [convertStartDateToObject]
  )

angular
  .module('greyhd')
  .factory('AdminUserResource', ['$resource', AdminUserResourceFactory])
