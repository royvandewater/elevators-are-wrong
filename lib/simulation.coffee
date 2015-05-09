debug = require('debug')('elevators-are-wrong:simulation')
_     = require 'lodash'

Building = require './building'
Person   = require './person'

class Simulation
  constructor: (options={}) ->
    @building = new Building _.pick(options, 'numElevators', 'numFloors', 'capacity')
    @people    = @generatePeople options.numPeople

  generatePeople: (numPeople) =>
    _.times numPeople, (i) =>
      new Person number: i, floorNumber: @building.getRandomFloorNumber()

  run: =>
    _.each @people, @attemptToEnterElevator

  attemptToEnterElevator: (person) =>
    @building.callElevator (elevator) =>
      return @attemptToEnterElevator(person) if elevator.isFull()
      elevator.insert person

module.exports = Simulation
