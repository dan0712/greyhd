'use strict'

class BoardController
  constructor: (Template, $rootScope, $state, company) ->
    Template.setBodyClasses('admin-body')

    vm = @
    vm.current_user = $rootScope.user
    vm.company = company
    $rootScope.$on 'company.update', (e, company) =>
      vm.company = company
    vm.is_menu_open = false

    $state.go('onboard.welcome') if vm.current_user.state == 'invited'

    vm.signOut = () ->
      $state.go('logout')

angular
  .module('greyhd')
  .controller('BoardController', ['Template', '$rootScope', '$state', 'company', BoardController])
