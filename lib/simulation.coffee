debug = require('debug')('elevators-are-wrong:simulation')
_     = require 'lodash'

Ticker = require './ticker'
Building = require './building'
Person   = require './person'

class Simulation
  constructor: (options={}) ->
    @ticker = new Ticker interval: options.interval
    @building = new Building _.extend(ticker: @ticker, _.pick(options, 'numElevators', 'numFloors', 'capacity'))
    @people    = @_generatePeople options.numPeople

  run: =>
    @ticker.boot()
    @building.boot()

    _.each @people, @navigateToFloor

    @ticker.on 'tick', =>
      if _.all @people, 'arrived'
        process.exit 0

  navigateToFloor: (person) =>
    person.say "I'm headed to #{person.destinationFloorNumber}"

    if person.destinationFloorNumber == 0
      person.arrive()
      return @building.insertPersonIntoFloorNumber person.number, 0

    @building.callElevatorTo 0

    @building.on 'elevator.open.0', (elevator) =>
      person.say 'hey, my elevator is here'
      if elevator.isFull() || elevator.isClosed()
        person.say 'nevermind, its full. I guess I\'ll wait for the next one'
        @building.callElevatorTo 0
        return

      @building.off 'elevator.open.0', arguments.callee
      elevator.insert person.number
      elevator.pushFloorButton person.destinationFloorNumber
      elevator.once ['open', person.destinationFloorNumber], =>
        person.arrive "this is me. See y'all later"
        elevator.remove person.number
        @building.insertPersonIntoFloorNumber person.number, person.destinationFloorNumber

  _generatePeople: (numPeople) =>
    _.times numPeople, (i) =>
      new Person({
        number: i
        destinationFloorNumber: 1 # @building.getRandomFloorNumber()
        ticker: @ticker
      })


module.exports = Simulation
