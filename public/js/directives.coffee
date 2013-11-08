@app.directive 'knob', ->
  (scope, element, attrs) ->
    $(element).val(scope.state.game.bets[scope.player.playerID]).knob()

@app.directive 'fadeInPlayer', ->
  (scope, elem, attrs) ->
    scope.newPlayerId = null