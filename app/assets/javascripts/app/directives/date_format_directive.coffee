'use strict'

DateFormatDirective = (dateFilter) ->
  link = (scope, el, attrs, ng_model) ->
    ng_model.$parsers.push((view_value) ->
      dateFilter(view_value, 'yyyy-MM-dd')
    )

  {
    restrict: 'A'
    require:'?ngModel'
    link: link
  }

angular
  .module('greyhd')
  .directive('dateFormat', ['dateFilter', DateFormatDirective])
