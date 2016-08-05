'use strict'

class AdminCompanyController
  constructor: ($stateParams, Upload, Template, Notification, $rootScope, company) ->
    max_gallery_images_length = 6
    datepicker = () ->
      options:
        formatYear: 'yy'
        startingDay: 1
        showWeeks: false
      isOpen: false
      toggle: ->
        @isOpen = !@isOpen

    @datepickers = []
    @origin = company
    @company = angular.copy(company)
    @company.milestones.forEach (milestone, index) =>
      @datepickers[index] = datepicker()

    @reset = ($event) ->
      $event.preventDefault()
      @company = angular.copy(company)

    @datepicker_format = 'yyyy/MM/dd'
    @date_pattern = '/^(\d{4})\/(\d{2})\/(\d{2})$/'
    @email_username_pattern = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*$/

    @isDefaultImage = (url) ->
      !!(url && url.match(/fallback/))

    @filteredGalleryImages = ->
      @company.gallery_images.filter (gallery_image) ->
        !gallery_image._destroy

    @showAddGalleryImageInput = ->
      @filteredGalleryImages().length < 6

    removeFile = (type, base) =>
      base = base || @company
      if base[type].entity_id
        base[type].remove_file = true
        base[type].file = {}
      else
        base[type] = null

    @removeLandingPageImage = ->
      removeFile('landing_page_image')

    @removeCompanyVideo = ->
      removeFile('company_video')

    @removeDisplayLogoImage = ->
      removeFile('display_logo_image')

    @removeMilestoneImage = (milestone) ->
      removeFile('milestone_image', milestone)

    @removeGalleryImage = (id) =>
      @company.gallery_images = @company.gallery_images.filter((gallery_image) =>
        gallery_image.entity_id || gallery_image.id != id
      )
      @company.gallery_images.forEach (gallery_image) =>
        gallery_image._destroy = true if gallery_image.id == id

    uploadFile = (type, file, base) ->
      Upload.upload
        url: '/api/v1/uploaded_files'
        method: 'POST'
        data: {type: type}
        file: file
      .then (response) =>
        if response.status == 201
          if type == 'gallery_image'
            base.gallery_images.push(response.data)
          else
            base[type] = response.data

    saveFile = (type, file, invalid_files, base) ->
      if invalid_files.indexOf(file) == -1
        uploadFile(type, file, base)

    limitGalleryImages = (files) =>
      if max_gallery_images_length - @filteredGalleryImages().length - files.length < 0
        Notification.error(I18n.t('admin.company.general.max_files_limit_reached'))
      files.slice(0, max_gallery_images_length - @filteredGalleryImages().length)

    @upload = (type, files, invalid_files, base) =>
      base = base || @company
      if type == 'gallery_image'
        files = limitGalleryImages(files)
      if invalid_files.length
        Notification.error(I18n.t('admin.company.general.invalid_image_file'))
      if angular.isArray(files)
        files.forEach (file) => saveFile(type, file, invalid_files, base)
      else if files
        saveFile(type, files, invalid_files, base)

    @save = ->
      return if @form.$invalid
      @company
        .$save()
        .then (company) =>
          $rootScope.$emit('company.update', company)
          Notification.success(
            title: I18n.t('notifications.success')
            message: I18n.t('notifications.admin.company.updated'))

    @addMilestone = ->
      @datepickers[@company.milestones.length] = datepicker()
      @company.milestones.push({})

    @addCompanyValue = ->
      @company.company_values.push({})

    removeFromAssociation = (association_key, $index) =>
      record = @company[association_key][$index]
      if record.id
        @company[association_key][$index]['_destroy'] = true
      else
        @company[association_key].splice($index, 1)

    removeDatepicker = ($index) =>
      @datepickers.splice($index, 1)

    @removeCompanyValue = ($index) ->
      removeFromAssociation('company_values', $index)
    @removeMilestone = ($index) ->
      removeFromAssociation('milestones', $index)
      removeDatepicker($index)

angular
  .module('greyhd')
  .controller('AdminCompanyController', [
    '$stateParams',
    'Upload',
    'Template',
    'Notification',
    '$rootScope',
    'company',
    AdminCompanyController
  ])
