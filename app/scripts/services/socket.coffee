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
    serverHostname = if $window.location.hostname is "localhost:9000" then "https://localhost:9001" else "http://pokerface-server.herokuapp.com:80"

    socketFactory
      ioSocket: io.connect serverHostname
