'use strict'

SplitUnderscoreFilter = ->
  (input) ->
    input.split('_').join(' ')

angular
  .module('greyhd')
  .filter('splitUnderscore', [SplitUnderscoreFilter])
