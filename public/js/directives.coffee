@app.directive('fadeInPlayer', ($timeout) ->
  return {
    link: (scope, elem, attrs) ->
      scope.newPlayerId = null
  }
)