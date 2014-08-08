'use strict'

###*
 # @ngdoc function
 # @name pokerfaceWebclientApp.controller:GameCtrl
 # @description
 # # GameCtrl
 # Controller of the pokerfaceWebclientApp
###
angular.module('pokerfaceWebclientApp')
  .controller 'GameCtrl', ($scope, socket, $cookies, $sce) ->
    $scope.cards = []
    $scope.newPlayerId = null
    $scope.videoSources = []

    videoStreams = []
    playersWithoutVideoQueue = []
    playersWithoutVideo = {}
    playersWithVideo = {}

    $scope.$watch "newPlayerId", ->
      $scope.newPlayerId = null

    $scope.renamePlayer = (name) ->
      socket.emit "renamePlayer", name

    $scope.startGame = ->
      socket.emit "startGame"

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

    socket.on "setPlayerId", (playerID) ->
      $scope.playerID = $cookies.playerID = playerID
      init()
      playersWithVideo[playerID] = true
      console.log "You are player #", playerID

    socket.on "updateState", (state) ->
      if state.players.length > $scope.state?.players.length
        $scope.newPlayerId = state.players[state.players.length - 1].playerID

      # Add any new players who are haven't received a video yet
      for player in state.players
        if !(playersWithVideo[player.playerID]?)
          playersWithoutVideoQueue.push(player.playerID)

      # Add videos to players who are still missing them
      while playersWithoutVideoQueue.length > 0 && videoStreams.length > 0
        newPlayerWithVideo = playersWithoutVideoQueue.shift()
        console.log "Adding video to player ", newPlayerWithVideo
        $scope.videoSources[newPlayerWithVideo] = $sce.trustAsResourceUrl(URL.createObjectURL(videoStreams.shift()))
        playersWithVideo[newPlayerWithVideo] = true
        delete playersWithoutVideo[newPlayerWithVideo]

      $scope.state = state
      $scope.cards = [] unless $scope.state.game? # if the game hasn't started yet, let's clear all cards
      console.log "New state: ", $scope.state

    # if $scope.users.currentPlayers.length == 0
    #   $scope.users.currentPlayers[0] = $scope.playerID
    # else
    #   for player in $scope.users.currentPlayers
    #     console.log($scope.users.currentPlayers)
    #     if $scope.users.currentPlayers[player].playerID == $scope.state.players[$scope.state.players.length - 1]
    #       break

    # console.log('$scope.users.currentPlayers: ', $scope.users.currentPlayers)

    # i = $scope.users.currentPlayers.length
    # $scope.users.currentPlayers[i] = $scope.playerID


    # if $scope.state.players?.length isnt state.players.length
    #   console.log('users: ', $scope.state.players)

    socket.on "addHand", (cards) ->
      $scope.cards[$scope.playerID] = cards
      console.log "New hand: ", cards

    socket.on "showHand", (data) ->
      $scope.cards[data.playerID] = data.cards
      console.log "Hand for player #{data.playerID}:", data.cards

    window.onunload = ->
      socket.emit "removePlayer"

    init = ->
      if PeerConnection
        console.log "Initializing my video stream"
        rtc.createStream
          video:
            mandatory: {}
            optional: []
          audio: true
        , (stream) ->
          $scope.$apply ->
            $scope.videoSources[$scope.playerID] = $sce.trustAsResourceUrl(URL.createObjectURL(stream))
          socket.emit "startedVideo", { playerID: $scope.playerID, streamUrl: URL.createObjectURL(stream) }

      else
        alert "Your browser is not supported or you have to turn on flags. In chrome you go to chrome://flags and turn on Enable PeerConnection remember to restart chrome"

      rtc.connect "ws://#{window.location.hostname}:9002"

      rtc.on "add remote stream", (stream, socketId) ->
        console.log("Got remote stream: ", URL.createObjectURL(stream))
        if playersWithoutVideoQueue.length > 0
          # Add the video we just received to the first player missing video
          newPlayerWithVideo = playersWithoutVideoQueue.shift()
          delete playersWithoutVideo[newPlayerWithVideo]
          console.log "Adding video to player ", newPlayerWithVideo
          $scope.$apply ->
            $scope.videoSources[newPlayerWithVideo] = $sce.trustAsResourceUrl(URL.createObjectURL(stream))
        else
          # Wait until we receive more players who need video
          console.log "Saving stream for later"
          videoStreams.push(stream)

    PeerConnection = window.PeerConnection or window.webkitPeerConnection00 or window.webkitRTCPeerConnection or window.mozRTCPeerConnection or window.RTCPeerConnection
