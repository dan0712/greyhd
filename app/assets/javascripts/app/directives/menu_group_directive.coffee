'use strict'

MenuGroupDirective = ($timeout) ->
  current = null

  link = (scope, el) ->
    toggleGroup = (event) ->
      angular
        .element(current)
        .parent()
        .removeClass(scope.class_name) if current

      if current == event.currentTarget
        current = null
        return

      current = event.currentTarget

      angular
        .element(current)
        .parent()
        .addClass(scope.class_name)

    setInitialCurrent = ->
      groups = angular.element(".#{scope.class_name}")
      return unless groups.length

      if scope.toggler_el_selector
        current = groups.find(scope.toggler_el_selector)[0]
      else
        current = groups[0]

    if scope.toggler_el_selector
      el.find(scope.toggler_el_selector).on('click', toggleGroup)
    else
      el.on('click', toggleGroup)

    $timeout(setInitialCurrent)
    scope.$on('$destroy', ->
      current = null
    )

  {
    restrict: 'A'
    scope:
      class_name: '@menuGroup'
      toggler_el_selector: '@menuGroupToggler'
    link: link
  }

angular
  .module('greyhd')
  .directive('menuGroup', ['$timeout', MenuGroupDirective])
