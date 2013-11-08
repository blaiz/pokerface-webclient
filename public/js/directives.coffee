@app.directive('knob', ->
    return {
        restrict: 'A',
        link: (scope, element, attrs) ->
            $(element).knob().val(1);
            $(element).knob().data('width', 700)
            console.log(attrs)

    };
);

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