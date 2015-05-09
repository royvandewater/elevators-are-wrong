class Floor
  constructor: (options={}) ->
    {@number} = options
    @contents = []

  insert: (personNumber) =>
    @contents.push personNumber

  toJSON: =>
    number: @number
    people: @contents

module.exports = Floor
