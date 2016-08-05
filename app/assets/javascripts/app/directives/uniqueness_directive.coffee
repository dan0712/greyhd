'use strict'

UniquenessDirective = ($timeout) ->
  isInvalidExceptUniqueness = (ng_model) ->
    Object.keys(ng_model.$error).length > 1

  link = (scope, el, attrs, ng_model) ->
    initial = ng_model.$viewValue
    timeout_id = null

    el.on('input', (event) =>
      if ng_model.$viewValue.length > 0
        scope.$apply(-> ng_model.$setValidity('uniqueness', false))
      else
        scope.$apply(-> ng_model.$setValidity('uniqueness', true))
        return

      return if isInvalidExceptUniqueness(ng_model)
      return scope.$apply(-> ng_model.$setValidity('uniqueness', true)) if ng_model.$viewValue == initial

      $timeout.cancel(timeout_id) if timeout_id

      timeout_id = $timeout(=>
        params = {}
        params[ng_model.$name] = ng_model.$viewValue

        scope
          .resource
          .constructor
          .query(params, (response) ->
            ng_model.$setValidity('uniqueness', true) unless response.length
          )
      , 500)
    )

  {
    restrict: 'A'
    require: 'ngModel'
    scope:
      resource: '=uniqueness'
    link: link
  }

angular
  .module('greyhd')
  .directive('uniqueness', ['$timeout', UniquenessDirective])
