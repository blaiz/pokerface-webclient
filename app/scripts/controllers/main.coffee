'use strict'

###*
 # @ngdoc function
 # @name pokerfaceWebclientApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the pokerfaceWebclientApp
###
angular.module('pokerfaceWebclientApp')
  .controller 'MainCtrl', ($scope, socket, $cookies) ->
    $scope.cards = []
    $scope.newPlayerId = null

    $scope.$watch "newPlayerId", ->
      $scope.newPlayerId = null

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
      $scope.playerId = $cookies.playerId = playerId
      console.log "You are player #", playerId

    socket.on "updateState", (state) ->
      if state.players.length > $scope.state?.players.length
        $scope.newPlayerId = state.players[state.players.length - 1].playerID

      $scope.state = state
      $scope.cards = [] unless $scope.state.game? # if the game hasn't started yet, let's clear all cards
      console.log "New state: ", $scope.state

    # if $scope.users.currentPlayers.length == 0
    #   $scope.users.currentPlayers[0] = $scope.playerId
    # else
    #   for player in $scope.users.currentPlayers
    #     console.log($scope.users.currentPlayers)
    #     if $scope.users.currentPlayers[player].playerID == $scope.state.players[$scope.state.players.length - 1]
    #       break

    # console.log('$scope.users.currentPlayers: ', $scope.users.currentPlayers)

    # i = $scope.users.currentPlayers.length
    # $scope.users.currentPlayers[i] = $scope.playerId


    # if $scope.state.players?.length isnt state.players.length
    #   console.log('users: ', $scope.state.players)

    socket.on "addHand", (cards) ->
      $scope.cards[$scope.playerId] = cards
      console.log "New hand: ", cards

    socket.on "showHand", (data) ->
      $scope.cards[data.playerId] = data.cards
      console.log "Hand for player #{data.playerId}:", data.cards
