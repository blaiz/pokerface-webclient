@app.filter "suits", ->
  (card) ->
    card.substr(1)
    .replace("S", "spades")
    .replace("H", "hearts")
    .replace("D", "diamonds")
    .replace("C", "clubs")