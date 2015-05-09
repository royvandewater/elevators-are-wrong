commander   = require 'commander'
Simulation  = require './lib/simulation'
packageJSON = require './package.json'

class Command
  run: =>
    commander
      .version packageJSON.version
      .option '-c, --capacity [count]', 'Number of people that fit in an elevator, default: 1'
      .option '-d, --days [count]', 'Number of days to simulate, default: 1'
      .option '-e, --elevators [count]', 'Number of elevators to simulate, default: 1'
      .option '-f, --floors [count]', 'Number of floors to simulate, default: 2'
      .option '-p, --people [count]', 'Number of people to simulate, default: 1'
      .parse process.argv

    capacity     = commander.capacity  ? 1
    numDays      = commander.days      ? 1
    numElevators = commander.elevators ? 1
    numFloors    = commander.floors    ? 2
    numPeople    = commander.people    ? 1

    simulation = new Simulation
      capacity: capacity
      numDays: numDays
      numElevators: numElevators
      numFloors: numFloors
      numPeople: numPeople

    simulation.run()


command = new Command
command.run()
