'use strict'

class AdminOnboardController
  constructor: (AdminUserResource, AdminWorkstreamResource, AdminTaskUserConnectionResource,
                AdminInvitesResource, Template, Notification, EmailPreview, user, teams, locations,
                managers, $state) ->
    Template.setTitle I18n.t('page_titles.onboard')

    vm = @
    vm.user = user
    vm.teams = teams
    vm.locations = locations
    vm.managers = managers

    if vm.user.id
      vm.workstreams = AdminWorkstreamResource.connected(user_id: vm.user.id)
    else
      vm.workstreams = []

    CreateProfileStep =
      name: I18n.t('admin.people.steps.create_profile')
      template_url: 'templates/admin/onboard/create_profile.html'

      isCompleted: ->
        !!vm.user.id

      continue: ->
        return if @form.$invalid

        create = ->
          vm
            .user
            .$save()
            .then ->
              AdminWorkstreamResource.connected(user_id: vm.user.id).$promise
            .then (workstreams) ->
              vm.active_step += 1
              vm.workstreams = workstreams

              Notification.success(
                title: I18n.t('notifications.success')
                message: I18n.t('notifications.admin.users.created')
              )

        update = ->
          vm
            .user
            .$update()
            .then ->
              vm.active_step += 1
              Notification.success(
                title: I18n.t('notifications.success')
                message: I18n.t('notifications.admin.users.updated')
              )

        if vm.user.id then update() else create()

    AssignTasksStep =
      name: I18n.t('admin.people.steps.assign_tasks')
      template_url: 'templates/admin/onboard/assign_tasks.html'

      continue_clicked: false

      initial_user_id: vm.user.id
      isCompleted: ->
        if @initial_user_id
          true
        else
          @continue_clicked

      continue: ->
        tasks = [].concat.apply([], vm.workstreams.map((workstream) -> workstream.tasks))

        AdminTaskUserConnectionResource
          .assign(user_id: vm.user.id, tasks: tasks)
          .$promise
          .then ->
            AdminWorkstreamResource.connected(user_id: vm.user.id).$promise
          .then (workstreams) =>
            vm.workstreams = workstreams
            vm.active_step += 1

            @continue_clicked = true
            @expand_all.closeAll()

            Notification.success(
              title: I18n.t('notifications.success')
              message: I18n.t('notifications.admin.users.tasks_assigned')
            )

      toggleConnection: (task) ->
        task.task_user_connection ?= {}

        if task.connected
          @setCreate(task.task_user_connection)
        else
          @setDestroy(task.task_user_connection)

      setCreate: (task_user_connection) ->
        delete task_user_connection._destroy
        task_user_connection._create = true unless task_user_connection.id

      setDestroy: (task_user_connection) ->
        delete task_user_connection._create
        task_user_connection._destroy = true if task_user_connection.id

      check_all:
        isAllChecked: (workstream) ->
          workstream.tasks.reduce((prev, current) ->
            prev && current.connected
          , true)

        text: (workstream) ->
          if @isAllChecked(workstream)
            I18n.t('admin.people.tasks.uncheck_all')
          else
            I18n.t('admin.people.tasks.check_all')

        toggle: (workstream) ->
          if @isAllChecked(workstream)
            @setAll(workstream, false)
          else
            @setAll(workstream, true)

        setAll: (workstream, value) ->
          workstream.tasks.forEach((task) ->
            task.connected = value
          )

      expand_all:
        expanded: false
        toggle: ->
          if @expanded
            @closeAll()
          else
            @openAll()
        openAll: ->
          @expanded = true
          vm.workstreams.forEach (workstream) ->
            workstream.is_open = true
        closeAll: ->
          @expanded = false
          vm.workstreams.forEach (workstream) ->
            workstream.is_open = false
        text: ->
          if @expanded
            I18n.t('admin.people.tasks.close_all')
          else
            I18n.t('admin.people.tasks.expand_all')

      isAnyAssignees: ->
        !!Object.keys(@assignees()).length

      assignees: ->
        assignees = {}
        vm.workstreams.forEach((workstream) ->
          workstream.tasks.forEach((task) ->
            return unless task.connected

            if assignees[task.owner.id]
              assignees[task.owner.id].tasks_count += 1
            else
              assignees[task.owner.id] = task.owner
              assignees[task.owner.id].tasks_count = 1
          ) if workstream.tasks
        )
        assignees

      workstreamsTotal: ->
        vm.workstreams.reduce((prev, current) ->
          if current.tasks.reduce((prev, current) ->
            prev || current.connected
          , false)
            prev += 1
          prev
        , 0)

      tasksTotal: ->
        vm.workstreams.reduce((prev, current) ->
          prev + current.tasks.filter((task) ->
            task.connected
          ).length
        , 0)

    CompleteStep =
      name: I18n.t('admin.people.steps.complete')
      template_url: 'templates/admin/onboard/complete.html'
      confirm_checked: false
      email_template:
        welcome_note: ''
        additional_information: ''

      formatDate: (date) ->
        moment(date).format('MMMM DD, YYYY')

      preview: ->
        EmailPreview.invite(vm.user, @email_template.welcome_note, @email_template.additional_information)

      continue: ->
        return unless @confirm_checked

        invite = new AdminInvitesResource(
          user_id: vm.user.id,
          welcome_note: @email_template.welcome_note,
          additional_information: @email_template.additional_information
        )

        invite
          .$create()
          .then ->
            $state.go('admin.people.manage')
            Notification.success(
              title: I18n.t('notifications.success')
              message: I18n.t('notifications.admin.users.invited')
            )

    vm.datepicker =
      toggle: ->
        @isOpen = !@isOpen
      open: ->
        @isOpen = true
      isOpen: false
      options:
        formatYear: 'yy'
        startingDay: 1
        showWeeks: false

    vm.active_step = 0

    vm.isStepActive = (index) ->
      index == vm.active_step

    vm.isStepDisabled = (index) ->
      if index == 0
        false
      else
        !vm.steps.slice(0, index).reduce((prev, current) ->
          prev && current.isCompleted()
        , true)

    vm.steps = [CreateProfileStep, AssignTasksStep, CompleteStep]

angular
  .module('greyhd')
  .controller('AdminOnboardController', [
    'AdminUserResource',
    'AdminWorkstreamResource',
    'AdminTaskUserConnectionResource',
    'AdminInvitesResource',
    'Template',
    'Notification',
    'EmailPreview',
    'user',
    'teams',
    'locations',
    'managers',
    '$state',
    AdminOnboardController
  ])
