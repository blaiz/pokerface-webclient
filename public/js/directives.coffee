@app.directive "knob", ->
  (scope, element, attrs) ->
    $(element).knob
      change: (value) ->
        console.log "Changed value of knob to: ", value
        scope.state.game.bets[scope.player.playerID] = value
        scope.$apply()
      readOnly: !(scope.state.game? and scope.state.game.turn is scope.playerId)

@app.directive 'fadeInPlayer', ->
  (scope, elem, attrs) ->
    scope.newPlayerId = null
