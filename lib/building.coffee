debug           = require('debug')('elevators-are-wrong:building')
_               = require 'lodash'
{EventEmitter2} = require 'eventemitter2'

Elevator = require './elevator'
Floor    = require './floor'

class Building extends EventEmitter2
  constructor: (options={}) ->
    super wildcard: true
    {@ticker}  = options
    @elevators = @_generateElevators options.numElevators, options.capacity
    @floors    = @_generateFloors options.numFloors

  boot: =>
    _.each @elevators, (elevator) =>
      elevator.on 'open.*', =>
        debug 'emitting', "elevator.open.#{elevator.floorNumber}"
        @emit ['elevator', 'open', elevator.floorNumber], elevator
      elevator.boot()

  callElevatorTo: (floorNumber) =>
    elevator = _.first @elevators
    elevator.gotoFloor floorNumber

  getRandomFloorNumber: =>
    _.sample(@floors).number

  insertPersonIntoFloorNumber: (personNumber,floorNumber) =>
    floor = _.findWhere @floors, number: floorNumber
    floor.insert personNumber

  toJSON: =>
    elevators: _.map @elevators, (elevator) => elevator.toJSON()
    floors: _.map @floors, (floor) => floor.toJSON()

  _generateElevators: (numElevators, capacity) =>
    _.times numElevators, (i) =>
      new Elevator number: i, capacity: capacity, ticker: @ticker

  _generateFloors: (numFloors) =>
    _.times numFloors, (i) =>
      new Floor number: i

module.exports = Building
