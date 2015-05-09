debug = require('debug')('elevators-are-wrong:simulation')
_     = require 'lodash'

Ticker = require './ticker'
Building = require './building'
Person   = require './person'

class Simulation
  constructor: (options={}) ->
    @ticker = new Ticker interval: 1000
    @building = new Building _.extend(ticker: @ticker, _.pick(options, 'numElevators', 'numFloors', 'capacity'))
    @people    = @_generatePeople options.numPeople

  run: =>
    @ticker.boot()
    @building.boot()

    _.each @people, @navigateToFloor

    # @ticker.on 'tick', =>
    #   debug JSON.stringify(@building.toJSON(), null, 2)

  navigateToFloor: (person) =>
    person.say "I'm headed to", person.destinationFloorNumber

    if person.destinationFloorNumber == 0
      debug 'person arrived at destination', person.number
      return @building.insertPersonIntoFloorNumber person.number, 0

    @building.callElevatorTo 0

    @building.on 'elevator.open.0', (elevator) =>
      person.say 'hey, my elevator is here'
      if elevator.isFull() || elevator.isClosed()
        person.say 'nevermind, its full. I guess I\'ll wait for the next one'
        return

      @building.off 'elevator.open.0', arguments.callee
      elevator.insert person.number
      elevator.pushFloorButton person.destinationFloorNumber
      elevator.on ['open', person.destinationFloorNumber], =>
        elevator.remove person.number
        building.insertPersonIntoFloorNumber person.number, person.destinationFloorNumber

  _generatePeople: (numPeople) =>
    _.times numPeople, (i) =>
      new Person({
        number: i
        destinationFloorNumber: @building.getRandomFloorNumber()
        ticker: @ticker
      })


module.exports = Simulation
