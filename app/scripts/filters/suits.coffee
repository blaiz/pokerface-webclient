'use strict'

###*
 # @ngdoc filter
 # @name pokerfaceWebclientApp.filter:suits
 # @function
 # @description
 # # suits
 # Filter in the pokerfaceWebclientApp.
###
angular.module('pokerfaceWebclientApp')
  .filter 'suits', ->
    (card) ->
      card.substr(1)
      .replace("S", "spades")
      .replace("H", "hearts")
      .replace("D", "diamonds")
      .replace("C", "clubs")
