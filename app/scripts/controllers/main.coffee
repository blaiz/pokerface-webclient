'use strict'

###*
 # @ngdoc function
 # @name pokerfaceWebclientApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the pokerfaceWebclientApp
###
angular.module('pokerfaceWebclientApp')
  .controller 'MainCtrl', ($scope, $http, $location) ->
    $scope.createGameRoom = ->
      $http.post("http://localhost:10000/gameroom").success (data) ->
        $location.path "/gameroom/#{data.id}"
