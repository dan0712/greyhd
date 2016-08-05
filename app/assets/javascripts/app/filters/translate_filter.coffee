'use strict'

TranslateFilter = ->
  (input, format) ->
    I18n.t(input, format)

angular
  .module('greyhd')
  .filter('translate', [TranslateFilter])
