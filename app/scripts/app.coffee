'use strict'

###*
 # @ngdoc overview
 # @name pokerfaceWebclientApp
 # @description
 # # pokerfaceWebclientApp
 #
 # Main module of the application.
###
angular
  .module('pokerfaceWebclientApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'btford.socket-io'
  ])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/gameroom/:gameRoomId',
        templateUrl: 'views/gameroom.html'
        controller: 'GameRoomCtrl'
      .otherwise
        redirectTo: '/'

