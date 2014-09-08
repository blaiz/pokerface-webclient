'use strict'

###*
 # @ngdoc function
 # @name pokerfaceWebclientApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the pokerfaceWebclientApp
###
angular.module('pokerfaceWebclientApp')
  .controller 'MainCtrl', ($scope, $http, $location, $window) ->
    $scope.createGameRoom = ->
      $http.post(
        "http://#{$window.location.hostname.indexOf("heroku") > -1 ? "pokerface-server.herokuapp.com:80" : "localhost:10000"}/gameroom"
      ).success (data) ->
        $location.path "/gameroom/#{data.id}"
