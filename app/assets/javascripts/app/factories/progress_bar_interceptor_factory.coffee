'use strict'

ProgressBarInterceptorFactory = (ngProgressFactory, $q) ->
  Interceptor = {}

  progress = null
  template_url_pattern = /^(templates)|(selectize)\//

  Interceptor.request = (config) ->
    return config if template_url_pattern.test(config.url)

    progress ?= ngProgressFactory.createInstance()
    progress.setColor('#29f50b')
    progress.start()

    config

  Interceptor.response = (response) ->
    return response if template_url_pattern.test(response.config.url)
    progress.complete()
    response

  Interceptor.requestError = (err) ->
    progress.complete()
    $q.reject(err)

  Interceptor.responseError = (err) ->
    progress.complete()
    $q.reject(err)

  Interceptor

angular
  .module('greyhd')
  .factory('ProgressBarInterceptor', [
    'ngProgressFactory',
    '$q',
    ProgressBarInterceptorFactory
  ])
