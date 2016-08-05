'use strict'

ErrorHandlerInterceptorFactory = ($q, $injector) ->
  Notification = null

  Interceptor = {}

  Interceptor.responseError = (response) ->
    error = response.data.errors[0]
    return $q.reject(response) unless error

    Notification ?= $injector.get('Notification')

    if error.status == '422'
      error.messages.forEach((message) =>
        Notification.error(title: error.details, message: message)
      )
    else
      Notification.error(title: error.title, message: error.details)

    $q.reject(response)

  Interceptor

angular
  .module('greyhd')
  .factory('ErrorHandlerInterceptor', [
    '$q',
    '$injector',
    ErrorHandlerInterceptorFactory
  ])
