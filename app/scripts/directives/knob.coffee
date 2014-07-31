'use strict'

###*
 # @ngdoc directive
 # @name pokerfaceWebclientApp.directive:knob
 # @description
 # # knob
###
angular.module('pokerfaceWebclientApp')
  .directive 'knob', ->
    (scope, element, attrs) ->
      $(element).knob
        change: (value) ->
          console.log "Changed value of knob to: ", value
          scope.state.game.bets[scope.player.playerID] = value
          scope.$apply()
        readOnly: !(scope.state.game? and scope.state.game.turn is scope.playerId)
