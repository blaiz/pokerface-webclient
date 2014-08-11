'use strict'

describe 'Controller: GameRoomCtrl', ->

  # load the controller's module
  beforeEach module 'pokerfaceWebclientApp'

  GameRoomCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    GameRoomCtrl = $controller 'GameRoomCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
