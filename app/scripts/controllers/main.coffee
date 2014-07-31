'use strict'

###*
 # @ngdoc function
 # @name pokerfaceWebclientApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the pokerfaceWebclientApp
###
angular.module('pokerfaceWebclientApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
