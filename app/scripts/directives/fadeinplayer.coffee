'use strict'

###*
 # @ngdoc directive
 # @name pokerfaceWebclientApp.directive:fadeInPlayer
 # @description
 # # fadeInPlayer
###
angular.module('pokerfaceWebclientApp')
  .directive 'fadeInPlayer', ->
    (scope, elem, attrs) ->
      scope.newPlayerId = null
