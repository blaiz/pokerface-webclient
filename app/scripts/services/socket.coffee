'use strict'

###*
 # @ngdoc service
 # @name pokerfaceWebclientApp.mySocket
 # @description
 # # mySocket
 # Factory in the pokerfaceWebclientApp.
###
angular.module('pokerfaceWebclientApp')
  .factory 'socket', (socketFactory, $window) ->
    serverHostname = "http://#{$window.location.hostname.indexOf("heroku") > -1 ? "pokerface-server.herokuapp.com:80" : "localhost:10000"}/gameroom"

    socketFactory
      ioSocket: io.connect serverHostname
