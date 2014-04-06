# test/bot.test.coffee

Bot = require '../bot'
Data = require './data'

exports.testSomething = (test)->
    test.expect 1
    test.ok true, "this assertion should pass"
    test.done()

exports.InitBotTest =
    setUp: (callback) ->
        callback()
    'can init bot': (test) ->
        data = new Data()
        bot = new Bot data.getInit()
        test.done()

exports.getLastMove1 =
    setUp: (callback) ->
        callback()
    'can load bot': (test) ->
        data = new Data()
        bot = new Bot data.getData()
        test.done()
    'arg 0': (test) ->
        data = new Data()
        bot = new Bot data.getData()
        bot.parseInput()
        result = bot.getLastMove()
        test.equal result.x, 6
        test.equal result.y, 6
        test.equal result.state, "missed"
        test.done()
    'arg 1000': (test) ->
        data = new Data()
        bot = new Bot data.getData()
        bot.parseInput()
        result = bot.getLastMove(1000)
        test.equal result, null
        test.done()
    'arg 3': (test) ->
        data = new Data()
        bot = new Bot data.getData()
        bot.parseInput()
        result = bot.getLastMove(1)
        test.equal result.x, 2
        test.equal result.y, 5
        test.equal result.state, "hit"
        test.done()

exports.getLastMove2 =
    'last hit': (test) ->
        data = new Data()
        bot = new Bot data.getData2()
        bot.parseInput()
        test.equal bot.getLastMove().state, "hit"
        test.done()
    'last missed': (test) ->
        data = new Data()
        bot = new Bot data.getData()
        bot.parseInput()
        test.equal bot.getLastMove().state, "missed"
        test.done()

exports.getState =
    'out of bound': (test) ->
        data = new Data()
        bot = new Bot data.getData()
        bot.parseInput()
        result = bot.getState 0, -1
        test.equal result, null
        test.done()

