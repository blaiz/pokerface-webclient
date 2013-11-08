@app = angular.module "PokerFace", []

@app.controller "MainCtrl", ($scope, socket) ->
    $scope.cards = []
    $scope.users = {
      currentPlayers: []
      newPlayer: null
    }

    $scope.renamePlayer = (name) ->
      socket.emit "renamePlayer", name

    $scope.startGame = ->
      socket.emit "startGame",

    $scope.fold = ->
      socket.emit "fold"

    ###
      check, bet, call, raise are all the same action
      check is bet 0
      call is bet same amount as last
      raise is bet double last amount or more
    ###
    $scope.bet = (amount) ->
      socket.emit "bet", amount

    $scope.showHand = ->
      socket.emit "showHand"

    socket.on "debug", (message) ->
      console.log message

    socket.on "setPlayerId", (playerId) ->
      $scope.playerId = playerId
      console.log "You are player #", playerId

    socket.on "updateState", (state) ->
      $scope.state = JSON.parse(state)
      console.log "New state: ", $scope.state

      if $scope.users.currentPlayers.length == 0
        $scope.users.currentPlayers[0] = $scope.playerId
      else
        for player in $scope.users.currentPlayers
          console.log($scope.users.currentPlayers)
          if $scope.users.currentPlayers[player].playerID == $scope.state.players[$scope.state.players.length - 1]
            break

      $scope.users.newPlayer = $scope.state.players[$scope.state.players.length - 1]

      console.log('$scope.users.currentPlayers: ', $scope.users.currentPlayers)

      i = $scope.users.currentPlayers.length
      $scope.users.currentPlayers[i] = $scope.playerId


      # if $scope.state.players?.length isnt state.players.length
      #   console.log('users: ', $scope.state.players)

    socket.on "addHand", (cards) ->
      $scope.cards[$scope.playerId] = cards
      console.log "New hand: ", cards

    socket.on "showHand", (data) ->
      data = JSON.parse(data)
      $scope.cards[data.playerId] = data.cards
      console.log "Hand for player #{data.playerId}:", data.cards