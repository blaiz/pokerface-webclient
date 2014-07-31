'use strict'

describe 'Directive: knob', ->

  # load the directive's module
  beforeEach module 'pokerfaceWebclientApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<knob></knob>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the knob directive'
