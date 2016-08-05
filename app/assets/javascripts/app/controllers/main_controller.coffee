'use strict'

class MainController
  constructor: (Template, $rootScope, $state) ->
    @Template = Template

    setContainerClasses = ->
      if !$state.current.abstract && !$state.includes('onboard.**')
        Template.setContainerClasses('main-admin')
      else
        Template.setContainerClasses('')

    setContainerClasses()
    $rootScope.$on('$stateChangeSuccess', -> setContainerClasses())

    goToHome = (user) ->
      if user.state == 'invited' then $state.go('onboard.welcome') else $state.go('home')

    goToLogin = () -> $state.go('login')

    goToHomeIfStateIsWrong = (user) ->
      if $state.includes('onboard.**')
        $state.go('home')
      else if $state.includes('board.**')
        $state.go('onboard.welcome')

    $rootScope.$on('auth:logout-success', goToLogin)
    $rootScope.$on('auth:validation-error', goToLogin)
    $rootScope.$on('auth:invalid', goToLogin)

    $rootScope.$on('auth:login-success', goToHome)
    $rootScope.$on('auth:validation-success', goToHomeIfStateIsWrong)
    $rootScope.$on('auth:registration-email-success', goToHome)

angular
  .module('greyhd')
  .controller('MainController', ['Template', '$rootScope', '$state', MainController])
