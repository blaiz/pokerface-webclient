@app.directive('fadeInPlayer', ($timeout) ->
  return {
    link: (scope, elem, attrs) ->

      if scope.player.playerID == scope.users.newPlayer.playerID
        # console.log('newUser: ', scope.users.newPlayer.playerID)
        $timeout( ->
          elem.removeClass('trans_out')
        , 0)
  }
)