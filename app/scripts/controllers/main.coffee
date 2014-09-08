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
        "http://#{if $window.location.hostname.indexOf("heroku") > -1 then "pokerface-server.herokuapp.com:80" else "localhost:10000"}/gameroom"
      ).success (data) ->
        $location.path "/gameroom/#{data.id}"
