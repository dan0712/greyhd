'use strict'

ShowErrorsDirective = () ->
  link = (scope, el, attrs, form, transclude_fn) ->
    scope.form = form
    scope.errors = form[scope.fieldName].$error

    transclude_fn(scope.$new(),(transcluded_content) ->
      el.append(transcluded_content)
    )

  {
    restrict: 'E'
    require : '^form'
    replace: true
    transclude: true
    scope:
      fieldName: '@field'
    link: link
    templateUrl: 'templates/directives/show_errors.html',
  }

ErrorDirective = () ->
  link = (scope, el, attrs) ->
    handler = (newValue) ->
      if newValue[attrs.error]
        el.show()
      else
        el.hide()

    removeWatch = scope.$watch('errors', handler, true)
    scope.$on('$destroy', -> removeWatch())

  {
    restrict: 'A'
    link: link
  }

angular
  .module('greyhd')
  .directive('showErrors', ShowErrorsDirective)
  .directive('error', ErrorDirective)
