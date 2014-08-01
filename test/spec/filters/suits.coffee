'use strict'

describe 'Filter: suits', ->

  # load the filter's module
  beforeEach module 'pokerfaceWebclientApp'

  # initialize a new instance of the filter before each test
  suits = {}
  beforeEach inject ($filter) ->
    suits = $filter 'suits'

  it 'should return the input prefixed with "suits filter:"', ->
    text = 'angularjs'
    expect(suits text).toBe ('suits filter: ' + text)
