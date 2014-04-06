###

  counter random bot: a simple improve of the random bot
  Author: Raphaël Dubigny (& Mikolaj Pawlikowski (mikolaj@pawlikowski.pl))

###

class Bot

  # global variables
  state: null
  moves: null

  constructor: (argv) ->
    @state = JSON.parse argv

  parseInput: () ->
    @moves = (move for move in @state.moves when parseInt(move.substr(0, 1)) is parseInt(@state.you))

  # utility methods
  rand: (n = 7) ->
    Math.floor(Math.random()*100000 + new Date().getTime()) % (n+1)

  returnMove: (x, y) ->
    console.log JSON.stringify
      move: "#{x}#{y}"

  isValidMove: (x, y) ->
    return (x in [0..7] and y in [0..7] and not @getState(x, y)?)

  # data accessors
  isDestroyed: (i) ->
    for destroyedBoat in @state.destroyed
      return true if parseInt(destroyedBoat) is i
    false

  getState: (x, y) ->
    for hit in @state.hit
      hitX = parseInt hit.substr(0, 1)
      hitY = parseInt hit.substr(1, 1)
      return "hit" if x is hitX and y is hitY

    for missed in @state.missed
      missedX = parseInt missed.substr(0, 1)
      missedY = parseInt missed.substr(1, 1)
      return "missed" if x is missedX and y is missedY

    null

  getLastMove: (last = 0) ->
    res = {}
    if @moves.length > last
      res.x = parseInt(@moves[@moves.length-(last+1)].substr(1, 1))
      res.y = parseInt(@moves[@moves.length-(last+1)].substr(2, 1))
      if @moves[@moves.length-(last+1)].slice(-1) is "3"
        res.state = "hit"
      else if @moves[@moves.length-(last+1)].slice(-1) is "1"
        res.state = "missed"
      return res
    else
      return null

  # bot's brain
  initPlay: () ->
    config = {}
    side = []
    for i in [2..5]
      attempt = @rand(3)
      while attempt in side
        attempt = @rand(3)
      side[i] = attempt

    for size in [2..5]
      a = @rand 1
      b = a + @rand(7 - size - (2 * a))
      if side[size] is 0
        x = a
        y = b
      if side[size] is 1
        x = b
        y = 7 - a
      if side[size] is 2
        x = 7 - a
        y = b + 1
      if side[size] is 3
        x = b + 1
        y = a

      if side[size] % 2 is 0
        orientation = "vertical"
      else
        orientation = "horizontal"

      config[size] =
        point: "#{x}#{y}"
        orientation: "#{orientation}"

    console.log JSON.stringify config

  returnRandomMove: () ->
    x = @rand()
    y = @rand()
    attempt = 0
    while attempt < 16 and (not (@isValidMove(x, y) and ((x + y) % 2) is 0 and ((x - y) % 4) is 0))
      attempt++ if ((x + y) % 2) is 0 and ((x - y) % 4) is 0
      x = @rand()
      y = @rand()
    if attempt is 16
      while attempt < 32 and (not (@isValidMove(x, y) and ((x + y) % 2) is 0 and ((x - y + 2) % 4) is 0))
        attempt++ if ((x + y) % 2) is 0 and ((x - y + 2) % 4) is 0
        x = @rand()
        y = @rand()
    if attempt is 32
      while not @isValidMove(x, y)
        x = @rand()
        y = @rand()

    @returnMove x, y

  getNextTarget: (x, y) ->
    # TODO take into acount the last two hit and not the last one only
    # TODO take into acount the destroyed ship
    return {'x': x - 1; 'y': y} if @isValidMove(x - 1, y)
    return {'x': x + 1; 'y': y} if @isValidMove(x + 1, y)
    return {'x': x; 'y': y - 1} if @isValidMove(x, y - 1)
    return {'x': x; 'y': y + 1} if @isValidMove(x, y + 1)

    return {'x': x + 4; 'y': y} if @isValidMove(x + 4, y) and @getState(x + 3, y) is "hit"
    return {'x': x + 3; 'y': y} if @isValidMove(x + 3, y) and @getState(x + 2, y) is "hit"
    return {'x': x + 2; 'y': y} if @isValidMove(x + 2, y) and @getState(x + 1, y) is "hit"

    return null

  play: () ->
    for i in [0..3]
      if @getLastMove(i)?.state is 'hit'
        move = @getLastMove(i)
        nextMove = @getNextTarget(move.x, move.y)
        if nextMove?
          @returnMove nextMove.x, nextMove.y
          return false

    @returnRandomMove()
    return false

  process: () ->
    if @state.cmd is 'init'
      @initPlay()
    else
      @parseInput()
      @play()

module.exports = Bot