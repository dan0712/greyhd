'use strict'

TaskAssignDirective = ($timeout) ->
  link = (scope, el) ->
    $timeout(() ->
      scope.$select.activate()
    )

    removeListener = scope.$on('uis:close', ->
      scope.task.isAssign = false
    )

    scope.$on('$destroy', -> removeListener())

  {
    require: 'ui-select'
    link: link
  }

angular
  .module('greyhd')
  .directive('taskAssign', ['$timeout', TaskAssignDirective])
