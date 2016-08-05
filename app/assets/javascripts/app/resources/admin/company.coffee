'use strict'

AdminCompanyResourceFactory = ($resource) ->
  convertMilestoneFromJsDates = (jsData) ->
    data = angular.copy(jsData)
    data.milestones = data.milestones?.map (milestone) ->
      milestone.happened_at = moment(milestone.happened_at).format('DD-MM-YYYY') if milestone.happened_at
      milestone
    angular.toJson(data)
  convertMilestoneToJsDates = (dataJson) ->
    data = angular.fromJson(dataJson)
    data.milestones = data.milestones?.map (milestone) ->
      milestone.happened_at = new Date(milestone.happened_at) if milestone.happened_at
      milestone
    data

  $resource('/api/v1/admin/companies/:action.json', {},
    current:
      params:
        action: 'current'
      transformResponse: [convertMilestoneToJsDates]
    save:
      method: 'PUT'
      transformRequest: [convertMilestoneFromJsDates]
      transformResponse: [convertMilestoneToJsDates]
  )

angular
  .module('greyhd')
  .factory('AdminCompanyResource', ['$resource', AdminCompanyResourceFactory])
