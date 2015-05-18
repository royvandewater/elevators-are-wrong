debug           = require 'debug'
_               = require 'lodash'
{EventEmitter2} = require 'eventemitter2'

class Elevator extends EventEmitter2
  constructor: (options={}) ->
    super wildcard: true
    {@capacity,@number,@ticker} = options
    @debug = debug "elevators-are-wrong:elevator:#{@number}"
    @contents = []
    @doorsAreOpen = false
    @floorNumber = 0
    @destinationFloorNumber = 0
    @requests = []
    @lastRequest = 0
    @currentTick = 0

  boot: =>
    @ticker.on 'tick', @tick

  closeDoors: =>
    @debug 'closeDoors', @floorNumber
    @doorsAreOpen = false
    @emit ['close', @floorNumber]

  insert: (personNumber) =>
    throw new Error('Elevator is full') if @isFull()
    @contents.push personNumber

  isFull: =>
    @capacity <= _.size @contents

  isClosed: =>
    !@doorsAreOpen

  openDoors: =>
    @debug 'openDoors', @floorNumber
    @doorsAreOpen = true
    @requests = _.without @requests, @floorNumber
    @destinationFloorNumber = null
    @emit ['open', @floorNumber]

  pushFloorButton: (floorNumber) =>
    @debug 'pushFloorButton', floorNumber
    @requests.push floorNumber
    @lastRequest = @currentTick

  remove: (personNumber) =>
    @contents = _.without @contents, personNumber

  shutdown: =>
    @ticker.off 'tick', @tick

  sortRequests: =>
    debug 'sortRequests', floorNumber: @floorNumber
    @requests = _.sortBy @requests
    [currentFloor, others] = _.partition @requests, (request) => request == @floorNumber
    @debug others: others, currentFloor: currentFloor
    @requests = _.union others, currentFloor

  tick: (tickNumber) =>
    @debug floor: @floorNumber, destination: @destinationFloorNumber, requests: @requests
    @currentTick = tickNumber

    return @openDoors() if @destinationFloorNumber == @floorNumber && !@doorsAreOpen
    return if _.isEmpty @requests
    @sortRequests()
    return @_goToDestination() if @destinationFloorNumber?

    if (@currentTick - @lastRequest) > 2
      @destinationFloorNumber = _.first @requests
      return @closeDoors()

  toJSON: =>
    number: @number
    contents: _.cloneDeep @contents
    requests: _.cloneDeep @requests

  _goToDestination: =>
    return @_goUp() if @destinationFloorNumber > @floorNumber
    return @_goDown() if @destinationFloorNumber < @floorNumber

  _goDown: =>
    @debug 'going down'
    @floorNumber -= 1

  _goUp: =>
    @debug 'going up'
    @floorNumber += 1

module.exports = Elevator
