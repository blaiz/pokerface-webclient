io = require("socket.io").listen 8081
poker = require "./vendor/node-poker"

clients = {}
players = []
table = null
n = 0
lastBet = 0

io.sockets.on "connection", (socket) ->
  if n is 0
    table = new poker.Table 1, 2, 2, 10, 200, 200
    console.log "Table created"
  if not clients[socket.id]?
    clients[socket.id] = {
      socket,
      n
    }
    players.push socket.id
    table.AddPlayer n, n, 'No Name', 200
    console.log "Player #{n} added"
    n++
  playerId = clients[socket.id].n
  socket.emit "setPlayerId", clients[socket.id].n
  sendState table

  socket.on "startGame", ->
    table.StartGame()
    for id, client of clients
      client.socket.emit "addHand", table.players[client.n].cards
      console.log "Player #{client.n} now has hand #{table.players[client.n].cards.toString()}"
    sendState table

  socket.on "fold", ->
    table.players[playerId].Fold()
    console.log "Player #{playerId} folded"
    sendState table

  socket.on "bet", (amount) ->
    if amount is 0
      table.players[playerId].Check()
      console.log "Player #{playerId} checked #{amount}"
    else if amount is table.players[playerId].chips
      table.players[playerId].AllIn()
      console.log "Player #{playerId} is all in!"
    else if amount is lastBet
      table.players[playerId].Call()
      console.log "Player #{playerId} called #{amount}"
    else
      table.players[playerId].Bet amount
      console.log "Player #{playerId} bet #{amount}"
      lastBet = amount
    sendState table

  socket.on "showHand", ->
    for id, client of clients
      client.socket.emit "showHand", {
          playerId,
          cards: table.players[playerId].cards
        }
    console.log "Player #{playerId} showed their hand"

  socket.on "removePlayer", ->
    table.players.splice playerId, 1
    sendState table

  socket.on "renamePlayer", (name) ->
    table.players[playerId].playerName = name
    sendState table

stringifyState = (state) ->
  cache = []
  state = JSON.stringify state, (key, value) ->
    if typeof value is "object" and value isnt null

      # Circular reference found, discard key
      return if cache.indexOf(value) isnt -1

      # Store value in our collection
      cache.push value
    value
  cache = null
  JSON.stringify removeCardsFromState(JSON.parse(state))

removeCardsFromState = (state) ->
  for player in state.players
    delete player.cards
  delete state.game?.deck
  return state

sendState = (state) ->
  for id, client of clients
    client.socket.emit "updateState", stringifyState state