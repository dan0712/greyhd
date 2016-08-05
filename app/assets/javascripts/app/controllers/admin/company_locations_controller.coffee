'use strict'

class AdminCompanyLocationsController
  constructor: (locations, Template, AdminLocationResource, AdminUserResource, Notification, $window) ->
    Template.setTitle I18n.t('page_titles.locations')

    vm = @

    vm.locations = locations
    vm.user_for_selection = null
    vm.in_edit = new AdminLocationResource(users: [])

    vm.delete = (location) ->
      return unless $window.confirm I18n.t('confirms.default')

      location
        .$delete()
        .then ->
          index = vm.locations.indexOf(location)
          vm.locations.splice(index, 1) if index > -1

          Notification.success(
            title: I18n.t('notifications.success')
            message: I18n.t('notifications.admin.locations.deleted')
          )

    vm.edit = (location) ->
      vm.in_edit = angular.copy(location)

    vm.cancel = ->
      vm.in_edit = new AdminLocationResource(users: [])

    vm.editTitle = ->
      if vm.in_edit.id
        I18n.t('admin.company.locations.edit_location')
      else
        I18n.t('admin.company.locations.create_new_location')

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
          AdminLocationResource.query().$promise
        .then (locations) ->
          vm.cancel()
          vm.locations = locations

          Notification.success(
            title: I18n.t('notifications.success')
            message: I18n.t("notifications.admin.locations.#{message}")
          )

angular
.module('greyhd')
.controller('AdminCompanyLocationsController', [
  'locations',
  'Template',
  'AdminLocationResource',
  'AdminUserResource',
  'Notification',
  '$window',
  AdminCompanyLocationsController
])
