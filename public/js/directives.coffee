@app.directive('fadeInPlayer', ($timeout) ->
	return {
		link: (scope, elem, attrs) ->
			$timeout(->
				console.log('fadeInPlayer')
				if !elem.hasClass('player_in')
					elem.addClass('player_in')
			, 1000)
	}
)