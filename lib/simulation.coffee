debug = require('debug')('elevators-are-wrong:simulation')
_     = require 'lodash'

Ticker = require './ticker'
Building = require './building'
Person   = require './person'

class Simulation
  constructor: (options={}) ->
    @ticker = new Ticker interval: 1000
    @building = new Building _.extend(ticker: @ticker, _.pick(options, 'numElevators', 'numFloors', 'capacity'))
    @people    = @generatePeople options.numPeople

  generatePeople: (numPeople) =>
    _.times numPeople, (i) =>
      new Person number: i, floorNumber: @building.getRandomFloorNumber()

  run: =>
    @building.boot()
    _.each @people, @navigateToFloor
    console.log JSON.stringify(@building.toJSON(), null, 2)
    @ticker.boot()

  navigateToFloor: (person) =>
    @building.callElevatorTo 1

    @building.on 'elevator.open.1', (elevator) =>
      return if elevator.isFull()
      @building.off 'elevator.open.1', arguments.callee
      elevator.insert person.number

module.exports = Simulation
