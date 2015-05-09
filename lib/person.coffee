debug = require 'debug'

class Person
  constructor: (options={}) ->
    {@number,@destinationFloorNumber,@ticker} = options
    @floorNumber = 0
    @debug = debug "elevators-are-wrong:person:#{@number}"

  say: =>
    @debug arguments...

module.exports = Person
