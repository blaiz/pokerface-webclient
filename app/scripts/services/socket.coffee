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
    serverURL = "http://#{if $window.location.hostname.indexOf("heroku") > -1 then "pokerface-server.herokuapp.com:80" else "localhost:10000"}/gameroom"

    socketFactory
      ioSocket: io.connect serverURL
