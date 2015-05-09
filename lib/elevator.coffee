_               = require 'lodash'
{EventEmitter2} = require 'eventemitter2'

class Elevator extends EventEmitter2
  constructor: (options={}) ->
    super wildcard: true
    {@capacity,@ticker} = options
    @contents = []
    @doorsAreOpen = false
    @floorNumber = 1
    @destinationFloorNumber = 1

  boot: =>
    @ticker.on 'tick', @tick

  gotoFloor: (@destinationFloorNumber) =>

  insert: (personNumber) =>
    throw new Error('Elevator is full') if @isFull()
    @contents.push personNumber

  isFull: =>
    @capacity <= _.size @contents

  openDoors: =>
    @doorsAreOpen = true
    @emit ['open', @floorNumber]

  shutdown: =>
    @ticker.off 'tick', @tick

  tick: =>
    return @floorNumber += 1 if @destinationFloorNumber > @floorNumber
    return @floorNumber -= 1 if @destinationFloorNumber < @floorNumber
    return @openDoors()

  toJSON: =>
    contents: _.cloneDeep @contents

module.exports = Elevator
