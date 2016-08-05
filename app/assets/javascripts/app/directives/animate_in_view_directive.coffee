angular.module 'app', []

AnimateInViewDirective = ($window, $timeout) ->
  restrict: 'A'
  scope:
    animate_in_view_timeout: '=?animateInViewTimeout'
    wait_for_animation: '@?waitForAnimation'
  link: (scope, element, attr) ->
    animation_triggered = false

    scrollHandler = ->
      $timeout.cancel(timeout_id) if timeout_id
      unless animation_triggered
        timeout_id = $timeout(=>
          triggerAnimation()
        , 500)

    triggerAnimation = ->
      return if animation_triggered

      if element[0].getBoundingClientRect().top < $window.innerHeight
        animation_triggered = true
        $timeout(=>
          angular.element(element).addClass(attr.animateInView)
        , scope.animate_in_view_timeout)

    if angular.isUndefined(scope.animate_in_view_timeout)
      scope.animate_in_view_timeout = 0

    if angular.isDefined(scope.wait_for_animation)
      animatedParent = $(document).find(scope.wait_for_animation)

    if animatedParent && animatedParent.length
      animatedParent.one 'animationend oAnimationEnd webkitAnimationEnd', -> triggerAnimation()
    else
      triggerAnimation()

    unless animation_triggered
      angular.element($window).on('scroll', scrollHandler)
      scope.$on '$destroy', ->
        angular.element($window).off('scroll', scrollHandler)


angular
  .module('greyhd')
  .directive('animateInView', ['$window', '$timeout', AnimateInViewDirective])
