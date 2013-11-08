@app = angular.module "PokerFace", []

@app.controller "MainCtrl", ($scope, socket) ->
    $scope.cards = []

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
      $scope.cards = [] unless $scope.state.game? # if the game hasn't started yet, let's clear all cards
      console.log "New state: ", $scope.state

    socket.on "addHand", (cards) ->
      $scope.cards[$scope.playerId] = cards
      console.log "New hand: ", cards

    socket.on "showHand", (data) ->
      data = JSON.parse(data)
      $scope.cards[data.playerId] = data.cards
      console.log "Hand for player #{data.playerId}:", data.cards