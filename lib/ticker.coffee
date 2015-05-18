debug           = require('debug')('elevators-are-wrong:ticker')
{EventEmitter2} = require 'eventemitter2'

class Ticker extends EventEmitter2
  constructor: ({interval: @interval}) ->
    super
    @setMaxListeners 100000
    @currentTick = 0
    @on 'tick', => debug 'tick'

  boot: =>
    @timer = setInterval @tick, @interval

  shutdown: =>
    clearInterval @timer

  tick: =>
    @emit 'tick', @currentTick
    @currentTick += 1

  ticksElapsed: =>
    @currentTick

module.exports = Ticker
