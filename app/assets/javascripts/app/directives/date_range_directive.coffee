'use strict'

DateRangeDirective = ->
  parseNgModelValue = (ng_model, default_value) ->
    value = if isNaN(ng_model.$viewValue) then default_value else ng_model.$viewValue
    parseInt(value, 10)

  link = (scope, el, attrs, ng_model) ->
    scope.events = [
      { id: 0, name: 'On' },
      { id: 1, name: 'After' },
      { id: 2, name: 'Before' }
    ]

    scope.selected_event_id = 0
    setInitialSelectedEventId = ->
      value = parseNgModelValue(ng_model, scope.default_value)

      if value > 0
        scope.selected_event_id = scope.events[1].id
      else if value == 0
        scope.selected_event_id = scope.events[0].id
      else if value < 0
        scope.selected_event_id = scope.events[2].id
      else
        scope.selected_event_id = scope.events[0].id

    scope.days = 0
    setInitialDays = ->
      value = parseNgModelValue(ng_model, scope.default_value)
      scope.days = Math.abs(value || scope.default_value)

    scope.needToShowDays = ->
      scope.selected_event_id != 0

    scope.setModelValue = ->
      value =
        switch scope.selected_event_id
          when 0 then 0
          when 1 then scope.days
          when 2 then -Math.abs(scope.days)

      ng_model.$setViewValue(value)

    ng_model.$render = () ->
      setInitialSelectedEventId()
      setInitialDays()
      scope.setModelValue()

  {
    restrict: 'E'
    require: '^ngModel'
    templateUrl: 'templates/directives/date_range.html'
    replace: true
    scope:
      default_value: '=default'
    link: link
  }

angular
  .module('greyhd')
  .directive('dateRange', [DateRangeDirective])
