debug = require('debug')('elevators-are-wrong:building')
_     = require 'lodash'

Elevator = require './elevator'
Floor    = require './floor'

class Building
  constructor: (options={}) ->
    @elevators = @_generateElevators options.numElevators, options.capacity
    @floors    = @_generateFloors options.numFloors

  callElevator: (callback=->) =>
    debug 'elevator called'

  getRandomFloorNumber: =>
    _.sample(@floors).number

  _generateElevators: (numElevators, capacity) =>
    _.times numElevators, (i) =>
      new Elevator number: i, capacity: capacity

  _generateFloors: (numFloors) =>
    _.times numFloors, (i) =>
      new Floor number: i



module.exports = Building
