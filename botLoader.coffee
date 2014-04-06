Bot = require './bot'

bot = new Bot process.argv.slice(2)
bot.process()