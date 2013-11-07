clientActions = [
  {
    action: "createTable",
    options: {
      smallBlind: 1,
      bigBlind: 2,
      baseChipCount: 200
    }
  },
  {
    action: "addPlayer",
    options: {
      name: "Susanne"
    }
  },
  {
    action: "removePlayer",
    options: {
      playerId: 3
    }
  },
  {
    action: "renamePlayer",
    options: {
      playerId: 2,
      name: "James"
    }
  },
  {
    action: "startGame"
  },
  {
    action: "fold",
    options: {
      playerId: 1
    }
  },
  # check, bet, call, raise are all the same action
  # check is bet 0
  # call is bet same amount as last
  # raise is bet double last amount or more
  {
    action: "bet",
    options: {
      playerId: 2,
      amount: 30
    }
  },
  {
    action: "showHoleCards",
    options: {
      playerId: 1
    }
  }
]

serverActions = [
  {
    action: "addCommunityCards",
    options: {
      cards: [
        "AC", "AD", "10S"
      ]
    }
  },
  {
    action: "addPlayer",
    options: {
      playerId: 1,
      name: "Peter"
    }
  }
  {
    action: "addHoleCards",
    options: {
      cards: [
        "2D", "7H"
      ]
    }
  },
  {
    action: "showHoldCards",
    options: {
      playerId: 3,
      cards: [
        "AC", "2H"
      ]
    }
  }
]

serverResponses = [
  # createTable
  {

  }
]