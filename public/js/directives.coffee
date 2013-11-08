@app.directive "knob", ->
  (scope, element, attrs) ->
    $(element).knob()

@app.directive 'fadeInPlayer', ->
  (scope, elem, attrs) ->
      scope.newPlayerId = null