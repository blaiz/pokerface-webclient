'use strict'

###*
 # @ngdoc directive
 # @name pokerfaceWebclientApp.directive:webrtc
 # @description
 # # webrtc
###
angular.module('pokerfaceWebclientApp')
  .directive 'webrtc', ->
    template: '
<div id="videos">
  <video id="you" class="flip" autoplay width="263" height="200" style="position: absolute; left: 0px; bottom: 0px;"></video>
</div>

<div class="buttonBox">
  <div id="fullscreen" class="button">Enter Full Screen</div>
  <div id="newRoom" class="button">Create A New Room</div>
</div>
'
    restrict: 'E'
    link: (scope, element, attrs) ->
      getNumPerRow = ->
        len = videos.length
        biggest = undefined

        # Ensure length is even for better division.
        len++  if len % 2 is 1
        biggest = Math.ceil(Math.sqrt(len))
        biggest++  while len % biggest isnt 0
        biggest
      subdivideVideos = ->
        perRow = getNumPerRow()
        numInRow = 0
        i = 0
        len = videos.length

        while i < len
          video = videos[i]
          setWH video, i
          numInRow = (numInRow + 1) % perRow
          i++
        return
      setWH = (video, i) ->
        perRow = getNumPerRow()
        perColumn = Math.ceil(videos.length / perRow)
        width = Math.floor((window.innerWidth) / perRow)
        height = Math.floor((window.innerHeight - 190) / perColumn)
        video.width = width
        video.height = height
        video.style.position = "absolute"
        video.style.left = (i % perRow) * width + "px"
        video.style.top = Math.floor(i / perRow) * height + "px"
        return
      cloneVideo = (domId, socketId) ->
        video = document.getElementById(domId)
        clone = video.cloneNode(false)
        clone.id = "remote" + socketId
        document.getElementById("videos").appendChild clone
        videos.push clone
        clone
      removeVideo = (socketId) ->
        video = document.getElementById("remote" + socketId)
        if video
          videos.splice videos.indexOf(video), 1
          video.parentNode.removeChild video
        return
      init = ->
        if PeerConnection
          rtc.createStream
            video:
              mandatory: {}
              optional: []

            audio: true
          , (stream) ->
            document.getElementById("you").src = URL.createObjectURL(stream)
            document.getElementById("you").play()
            return

        else
          alert "Your browser is not supported or you have to turn on flags. In chrome you go to chrome://flags and turn on Enable PeerConnection remember to restart chrome"
        rtc.connect "ws://localhost:9002"
        rtc.on "add remote stream", (stream, socketId) ->
          console.log "ADDING REMOTE STREAM..."
          clone = cloneVideo("you", socketId)
          document.getElementById(clone.id).setAttribute "class", ""
          rtc.attachStream stream, clone.id
          subdivideVideos()
          return

        rtc.on "disconnect stream", (data) ->
          console.log "remove " + data
          removeVideo data
          return

        return
      videos = []
      PeerConnection = window.PeerConnection or window.webkitPeerConnection00 or window.webkitRTCPeerConnection or window.mozRTCPeerConnection or window.RTCPeerConnection

      angular.element init
