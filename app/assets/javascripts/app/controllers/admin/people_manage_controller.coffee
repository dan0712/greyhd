'use strict'

class AdminPeopleManageController
  constructor: (users, teams, locations, AdminUserResource, $state, Template) ->
    Template.setTitle I18n.t('page_titles.manage')

    vm = @

    vm.users = users
    vm.teams = teams
    vm.locations = locations

    vm.roles = [
      { id: null, name: I18n.t('admin.people.manage.all_roles') },
      { id: 0, name: I18n.t('models.user.roles.employee') },
      { id: 1, name: I18n.t('models.user.roles.admin') },
      { id: 2, name: I18n.t('models.user.roles.account_owner') }
    ]

    vm.isEditable = (user) ->
      user.state == 'new'

    vm.edit = (user) ->
      $state.go('admin.people.onboardEdit', id: user.id)

    vm.filter =
      values:
        term: ''
        role: null
        team_id: null
        location_id: null

      init: ->
        vm.teams.unshift(id: null, name: I18n.t('admin.people.manage.all_teams'))
        vm.locations.unshift(id: null, name: I18n.t('admin.people.manage.all_locations'))

      go: ->
        params = {}

        for name, value of @values
          if value != '' &&  value != null
            params[name] = value

        AdminUserResource
          .query(params)
          .$promise
          .then (response) ->
            vm.users = response

    vm.filter.init()

angular
  .module('greyhd')
  .controller('AdminPeopleManageController', [
    'users',
    'teams',
    'locations',
    'AdminUserResource',
    '$state',
    'Template',
    AdminPeopleManageController
  ])
