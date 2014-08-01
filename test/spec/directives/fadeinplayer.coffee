'use strict'

describe 'Directive: fadeInPlayer', ->

  # load the directive's module
  beforeEach module 'pokerfaceWebclientApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<fade-in-player></fade-in-player>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the fadeInPlayer directive'
