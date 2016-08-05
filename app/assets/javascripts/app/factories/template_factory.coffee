'use strict'

TemplateFactory = () ->
  Template =
    title: ''
    body_classes: ''
    container_classes: ''

    getTitle: ->
      @title || I18n.t('default_title')

    setTitle: (new_title) ->
      @title = new_title
      @

    getBodyClasses: ->
      @body_classes || ''

    setBodyClasses: (new_body_classes) ->
      @body_classes = new_body_classes
      @

    getContainerClasses: ->
      @container_classes || ''

    setContainerClasses: (new_container_classes) ->
      @container_classes = new_container_classes
      @

angular
  .module('greyhd')
  .factory('Template', [TemplateFactory])
