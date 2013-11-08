# Snippet from http://www.html5rocks.com/en/tutorials/frameworks/angular-websockets/
@app.factory "socket", ($rootScope) ->
  socket = io.connect 'http://localhost:8081'
  on: (eventName, callback) ->
    socket.on eventName, ->
      args = arguments
      $rootScope.$apply ->
        callback.apply socket, args
  emit: (eventName, data, callback) ->
    socket.emit eventName, data, ->
      args = arguments
      $rootScope.$apply ->
        callback.apply socket, args  if callback