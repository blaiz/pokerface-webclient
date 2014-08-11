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
    serverHostname = "http://#{$window.location.hostname}:#{if $window.location.port is "80" then 80 else 10001}/gameroom"

    socketFactory
      ioSocket: io.connect serverHostname
