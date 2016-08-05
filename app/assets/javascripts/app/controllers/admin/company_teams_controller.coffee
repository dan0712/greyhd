'use strict'

class AdminCompanyTeamsController
  constructor: (teams, Template, AdminTeamResource, AdminUserResource, Notification, $window) ->
    Template.setTitle I18n.t('page_titles.teams')

    vm = @

    vm.teams = teams
    vm.user_for_selection = null
    vm.in_edit = new AdminTeamResource(users: [])

    vm.delete = (team) ->
      return unless $window.confirm I18n.t('confirms.default')

      team
        .$delete()
        .then ->
          index = vm.teams.indexOf(team)
          vm.teams.splice(index, 1) if index > -1

          Notification.success(
            title: I18n.t('notifications.success')
            message: I18n.t('notifications.admin.teams.deleted')
          )

    vm.edit = (team) ->
      vm.in_edit = angular.copy(team)

    vm.cancel = ->
      vm.in_edit = new AdminTeamResource(users: [])

    vm.editTitle = ->
      if vm.in_edit.id
        I18n.t('admin.company.teams.edit_team')
      else
        I18n.t('admin.company.teams.create_new_team')

    vm.selectOwner = (owner) ->
      vm.in_edit.owner_id = owner.id

    vm.clearOwner = ($event) ->
      vm.in_edit.owner = null
      vm.in_edit.owner_id = null

      $event.stopPropagation()

    vm.selectMember = (user) ->
      vm.in_edit.users.push(user)
      vm.user_for_selection = null

    vm.removeMember = (user) ->
      index = vm.in_edit.users.indexOf(user)
      vm.in_edit.users.splice(index, 1) if index > -1

    vm.searchOwner = ($select) ->
      term = $select.search

      if term
        AdminUserResource
          .query(term: term, registered: true)
          .$promise
          .then (users) ->
            $select.users = users
      else
        $select.users = []

    vm.searchMembers = ($select, exclude_users = []) ->
      term = $select.search
      exclude_ids = exclude_users.map (user) -> user.id

      if term
        AdminUserResource
          .query(term: term, 'exclude_ids[]': exclude_ids)
          .$promise
          .then (users) ->
            $select.users = users
      else
        $select.users = []

    vm.save = ->
      method = if vm.in_edit.id then '$update' else '$save'
      message = if vm.in_edit.id then 'updated' else 'created'

      vm
        .in_edit[method]()
        .then () ->
          AdminTeamResource.query().$promise
        .then (teams) ->
          vm.cancel()
          vm.teams = teams

          Notification.success(
            title: I18n.t('notifications.success')
            message: I18n.t("notifications.admin.teams.#{message}")
          )

angular
  .module('greyhd')
  .controller('AdminCompanyTeamsController', [
    'teams',
    'Template',
    'AdminTeamResource',
    'AdminUserResource',
    'Notification',
    '$window',
    AdminCompanyTeamsController
  ])
