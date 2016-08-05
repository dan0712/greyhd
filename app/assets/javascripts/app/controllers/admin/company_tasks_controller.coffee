'use strict'

class AdminCompanyTasksController
  constructor: (workstreams, Template, AdminTaskResource, AdminUserResource,
                AdminWorkstreamResource, Notification, Upload, $window) ->
    Template.setTitle I18n.t('page_titles.tasks')

    vm = @

    vm.workstreams = workstreams
    vm.current_workstream = null
    vm.workstream_in_edit = null
    vm.workstream_form_shown = false
    vm.current_task = null
    vm.current_task_form = null
    current_task_initial = null
    workstream_in_edit_initial = null

    resetCurrentTask = ->
      vm.current_task = null
      current_task_initial = null

    workstreamByTask = (task) ->
      vm.workstreams.reduce((found, workstream) ->
        if found
          found
        else
          workstream if workstream.id == task.workstream_id
      , null)

    vm.editWorkstream = (workstream = new AdminWorkstreamResource) ->
      workstream_in_edit_initial = angular.copy(workstream) if workstream.id
      vm.workstream_in_edit = workstream
      vm.workstream_form_shown = true

    vm.cancelWorkstreamForm = ->
      if workstream_in_edit_initial && vm.workstream_in_edit
        index = vm.workstreams.indexOf(vm.workstream_in_edit)
        vm.workstreams[index].name = workstream_in_edit_initial.name if index > -1
        vm.current_workstream.name = workstream_in_edit_initial.name if vm.current_workstream

      workstream_in_edit_initial = null
      vm.workstream_in_edit = null
      vm.workstream_form_shown = false

    vm.isCurrentWorkstream = (workstream) ->
      vm.current_workstream && vm.current_workstream.id == workstream.id

    vm.toggleWorkstream = (workstream) ->
      vm.reorder_tasks.disable()

      if vm.isCurrentWorkstream(workstream)
        resetCurrentTask()
        vm.current_workstream = null
      else
        AdminTaskResource
          .query(workstream_id: workstream.id)
          .$promise
          .then (tasks) ->
            resetCurrentTask()
            workstream.tasks = tasks
            vm.current_workstream = workstream

    vm.saveWorkstream = ->
      return if vm.workstream_form.$invalid

      create = ->
        vm.workstream_in_edit
          .$save()
          .then ->
            vm.workstreams.push(vm.workstream_in_edit)
            vm.cancelWorkstreamForm()

            Notification.success(
              title: I18n.t('notifications.success')
              message: I18n.t('notifications.admin.workstreams.created')
            )

      update = ->
        tasks = vm.workstream_in_edit.tasks

        vm.workstream_in_edit
          .$update()
          .then ->
            vm.workstream_in_edit.tasks = tasks

            workstream_in_edit_initial = angular.copy(vm.workstream_in_edit)
            vm.cancelWorkstreamForm()

            Notification.success(
              title: I18n.t('notifications.success')
              message: I18n.t('notifications.admin.workstreams.updated')
            )

      if vm.workstream_in_edit.id then update() else create()

    vm.deleteWorkstream = ->
      return unless $window.confirm I18n.t('confirms.default')

      vm.current_workstream
        .$delete()
        .then ->
          index = vm.workstreams.indexOf(vm.current_workstream)
          vm.workstreams.splice(index, 1) if index > -1

          vm.current_workstream = null
          vm.cancelWorkstreamForm()

          Notification.success(
            title: I18n.t('notifications.success')
            message: I18n.t('notifications.admin.workstreams.deleted')
          )

    vm.dragAndDropWorkstreams =
      orderChanged: (event) ->
        workstream = event.dest.sortableScope.modelValue[event.dest.index]

        AdminWorkstreamResource
          .update({ id: workstream.id }, { position: event.dest.index + 1 })
          .$promise
          .then (response) ->
            workstream.position = response.position

    vm.reorder_workstreams =
      state: false
      enable: ->
        @state = true
      disable: ->
        @state = false
      toggle: ->
        if @state then @disable() else @enable()
      text: ->
        if @state
          I18n.t('admin.company.tasks.complete')
        else
          I18n.t('admin.company.tasks.reorder')


    vm.isCurrentTask = (task) ->
      if vm.current_task
        if vm.current_task.id && task.id
          vm.current_task.id == task.id
        else if vm.current_task.$$hashKey && task.$$hashKey
          vm.current_task.$$hashKey == task.$$hashKey
      else
        false

    vm.toggleTask = (task) ->
      if vm.isCurrentTask(task)
        resetCurrentTask()
      else
        vm.current_task = task
        current_task_initial = angular.copy(task)

    vm.deleteTask = (task) ->
      return unless $window.confirm I18n.t('confirms.default')

      task
        .$delete()
        .then ->
          workstream = workstreamByTask(task)
          index = workstream.tasks.indexOf(task)

          workstream.tasks_count -= 1
          workstream.tasks.splice(index, 1) if index > -1

          Notification.success(
            title: I18n.t('notifications.success')
            message: I18n.t('notifications.admin.tasks.deleted')
          )

    vm.addNewTask = ->
      return if vm.reorder_tasks.state

      new_task = new AdminTaskResource(workstream_id: vm.current_workstream.id)

      vm.current_workstream.tasks.push(new_task)
      vm.toggleTask(new_task)

    vm.cancelTaskForm = ->
      workstream = workstreamByTask(vm.current_task)
      index = workstream.tasks.indexOf(vm.current_task)

      if vm.current_task.id
        workstream.tasks[index] = current_task_initial if index > -1
      else
        workstream.tasks.splice(index, 1) if index > -1

      vm.current_task = null

    vm.enableTaskAssign = (task) ->
      task.isAssign = true

    vm.disableTaskAssign = (task) ->
      task.isAssign = false

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

    vm.selectOwner = (owner, task) ->
      task.owner = owner
      task.owner_id = owner.id
      vm.disableTaskAssign(task)

    vm.saveTask = ->
      return if vm.current_task.form.$invalid

      form = vm.current_task.form

      create = ->
        vm.current_task
          .$create()
          .then ->
            current_task_initial = angular.copy(vm.current_task)
            vm.current_task.form = form

            workstream = workstreamByTask(vm.current_task)
            workstream.tasks_count += 1

            Notification.success(
              title: I18n.t('notifications.success')
              message: I18n.t('notifications.admin.tasks.created')
            )

      update = ->
        vm.current_task
          .$update()
          .then ->
            current_task_initial = angular.copy(vm.current_task)
            vm.current_task.form = form

            Notification.success(
              title: I18n.t('notifications.success')
              message: I18n.t('notifications.admin.tasks.updated')
            )

      if vm.current_task.id then update() else create()

    vm.dragAndDropTasks =
      orderChanged: (event) ->
        task = event.dest.sortableScope.modelValue[event.dest.index]

        AdminTaskResource
          .update({ id: task.id }, { position: event.dest.index + 1 })
          .$promise
          .then (response) ->
            task.position = response.position

    vm.reorder_tasks =
      state: false
      enable: ->
        @state = true
        vm.current_workstream.tasks = vm.current_workstream.tasks.filter((task) ->
          task.id
        )
      disable: ->
        @state = false
      toggle: ->
        if @state then @disable() else @enable()
      text: ->
        if @state
          I18n.t('admin.company.tasks.complete')
        else
          I18n.t('admin.company.tasks.reorder')

    vm.uploadAttachment = (task, file) ->
      return unless file

      options =
        url: '/api/v1/uploaded_files'
        method: 'POST'
        data:
          type: 'attachment'
        file: file

      Upload
        .upload(options)
        .then (response) ->
          task.attachments ?= []
          task.attachments.push(response.data) if response.status == 201

    vm.removeAttachment = (task, attachment) ->
      index = task.attachments.indexOf(attachment)
      task.attachments.splice(index, 1) if index > -1

    vm.tasksTotal = ->
      vm.workstreams.reduce((count, workstream) ->
        count + workstream.tasks_count
      , 0)

    vm.tasksText = (count) ->
      message =
        if count == 1
          I18n.t('admin.company.tasks.single')
        else
          I18n.t('admin.company.tasks.multiple')

      "#{count} #{message}"

angular
  .module('greyhd')
  .controller('AdminCompanyTasksController', [
    'workstreams',
    'Template',
    'AdminTaskResource',
    'AdminUserResource',
    'AdminWorkstreamResource',
    'Notification',
    'Upload',
    '$window',
    AdminCompanyTasksController
  ])
