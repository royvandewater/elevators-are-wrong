_               = require 'lodash'
{EventEmitter2} = require 'eventemitter2'

class Elevator extends EventEmitter2
  constructor: (options={}) ->
    super wildcard: true
    {@capacity,@number,@ticker} = options
    @contents = []
    @doorsAreOpen = false
    @floorNumber = 1
    @destinationFloorNumber = 1
    @requests = []
    @lastRequest = 0
    @currentTick = 0

  boot: =>
    @ticker.on 'tick', @tick

  closeDoors: =>
    @doorsAreOpen = false
    @emit ['close', @floorNumber]

  gotoFloor: (@destinationFloorNumber) =>

  insert: (personNumber) =>
    throw new Error('Elevator is full') if @isFull()
    @contents.push personNumber

  isFull: =>
    @capacity <= _.size @contents

  isClosed: =>
    !@doorsAreOpen

  openDoors: =>
    @doorsAreOpen = true
    @emit ['open', @floorNumber]

  pushFloorButton: (floorNumber) =>
    @requests.push floorNumber
    @requests = _.sort _.uniq @requests
    @lastRequest = @currentTick

  remove: (personNumber) =>
    _.remove @contents, personNumber

  shutdown: =>
    @ticker.off 'tick', @tick

  tick: (tickNumber) =>
    @currentTick = tickNumber
    return unless @destinationFloorNumber
    return @floorNumber += 1 if @destinationFloorNumber > @floorNumber
    return @floorNumber -= 1 if @destinationFloorNumber < @floorNumber
    return @openDoors() if @destinationFloorNumber == @floorNumber && !@doorsAreOpen
    if (@currentTick - @lastRequest) > 2
      @destinationFloorNumber = _.first @requests
      @closeDoors()

  toJSON: =>
    number: @number
    contents: _.cloneDeep @contents

module.exports = Elevator
