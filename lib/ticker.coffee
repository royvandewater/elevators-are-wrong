debug           = require('debug')('elevators-are-wrong:ticker')
{EventEmitter2} = require 'eventemitter2'

class Ticker extends EventEmitter2
  constructor: ({interval: @interval}) ->
    @on 'tick', => debug 'tick'

  boot: =>
    @timer = setInterval (=> @emit 'tick'), @interval

  shutdown: =>
    clearInterval @timer

module.exports = Ticker
