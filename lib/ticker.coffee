debug           = require('debug')('elevators-are-wrong:ticker')
{EventEmitter2} = require 'eventemitter2'

class Ticker extends EventEmitter2
  constructor: ({interval: @interval}) ->
    @currentTick = 0
    @on 'tick', => debug 'tick'

  boot: =>
    @timer = setInterval @tick, @interval

  tick: =>
    @emit 'tick', @currentTick
    @currentTick += 1

  shutdown: =>
    clearInterval @timer

module.exports = Ticker
