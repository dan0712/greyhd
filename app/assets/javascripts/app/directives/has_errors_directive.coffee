'use strict'

HasErrorsDirective = () ->
  link = (scope, el, attrs, form) ->
    watchValue = () ->
      form[scope.field].$invalid && (form[scope.field].$dirty || form.$submitted)

    handler = (new_value) ->
      if new_value
        el.addClass('with-error')
      else
        el.removeClass('with-error')

    removeWatch = scope.$watch(watchValue, handler)

    scope.$on('$destroy', -> removeWatch())

  {
    restrict: 'A'
    require : '^form'
    scope:
      field: '@hasErrors'
    link: link
  }

angular
  .module('greyhd')
  .directive('hasErrors', [HasErrorsDirective])
