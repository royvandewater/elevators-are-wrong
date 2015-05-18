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
        status = success: true, ticksElapsed: @ticker.ticksElapsed()
        console.log JSON.stringify(status, null, 2)
        process.exit 0

  navigateToFloor: (person) =>
    person.say "I'm headed to #{person.destinationFloorNumber}"
    availableElevators = []

    if person.destinationFloorNumber == 0
      person.arrive()
      return @building.insertPersonIntoFloorNumber person.number, 0

    @building.callElevatorTo 0

    @building.on 'elevator.open.0', (elevator) =>
      availableElevators = _.union availableElevators, [elevator]

    @ticker.on 'tick', =>
      availableElevators = _.where availableElevators, floorNumber:0, doorsAreOpen: true
      availableElevators = _.without availableElevators, (elevator) => elevator.isFull()
      debug 'availableElevators', _.pluck(availableElevators, 'number')
      if _.isEmpty availableElevators
        @building.callElevatorTo 0
        return

      elevator = _.sample availableElevators
      @ticker.off 'tick', arguments.callee
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
        destinationFloorNumber: @building.getRandomFloorNumber()
        ticker: @ticker
      })


module.exports = Simulation
