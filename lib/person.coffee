debug = require 'debug'

class Person
  constructor: (options={}) ->
    {@number,@destinationFloorNumber,@ticker} = options
    @floorNumber = 0
    @debug = debug "elevators-are-wrong:person:#{@number}"
    @arrived = false

  arrive: (message) =>
    @arrived = true
    @say message ? "Arrived at my destination"

  say: =>
    @debug arguments...

module.exports = Person
