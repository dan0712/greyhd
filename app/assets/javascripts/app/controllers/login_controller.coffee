'use strict'

class LoginController
  constructor: (Template, $auth, $scope, company) ->
    Template.setTitle(I18n.t('log_in.page_title'))

    vm = @
    vm.company = company
    vm.login_data =
      email: ''
      password: ''

    vm.login = () ->
      if vm.form.$valid
        vm.form.server_response = ''
        $auth.submitLogin(vm.login_data)

    removeListener = $scope.$on('auth:login-error', (event, response) =>
      error = response.errors[0] || {}
      vm.form.server_response = error.details
    )
    $scope.$on('$destroy', -> removeListener())

angular
  .module('greyhd')
  .controller('LoginController', ['Template', '$auth', '$scope', 'company', LoginController])
