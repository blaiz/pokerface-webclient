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
      .when '/game',
        templateUrl: 'views/game.html'
        controller: 'GameCtrl'
      .otherwise
        redirectTo: '/'

