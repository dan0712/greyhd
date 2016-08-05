'use strict'

CapitalizeFilter = ->
  (input) ->
    input.toLowerCase().split(' ').map((word) ->
      word[0].toUpperCase() + word.substring(1)
    ).join(' ')

angular
  .module('greyhd')
  .filter('capitalize', [CapitalizeFilter])
