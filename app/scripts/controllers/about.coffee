'use strict'

###*
 # @ngdoc function
 # @name pokerfaceWebclientApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the pokerfaceWebclientApp
###
angular.module('pokerfaceWebclientApp')
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
