'use strict'

UiSrefActiveIfDirective = ($state) ->
  link = (scope, el) ->
    active = false
    states = scope.states.split(' ')
    class_name = scope.class_name || 'active'

    checkState = ->
      active = false

      states.forEach (state) ->
        if $state.includes(state) || $state.is(state)
          active = true

      if active
        el.addClass(class_name)
      else
        el.removeClass(class_name)

    checkState()

    removeListener = scope.$on('$stateChangeSuccess', checkState)
    scope.$on('$destroy', -> removeListener())

  {
    restrict: 'A'
    scope:
      states: '=uiSrefActiveIf'
      class_name: '@uiSrefActiveClass'
    link: link
  }

angular
  .module('greyhd')
  .directive('uiSrefActiveIf', ['$state', UiSrefActiveIfDirective])
