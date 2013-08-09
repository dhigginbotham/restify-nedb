### Examples Usage ###
# copy & paste this into your express app directory and 
# include it like we have in `app.coffee`

_ = require "lodash"
express = require "express"
app = module.exports = express()

nedb = require("../lib").mount

cfg = require "./config"

cfg.ds (err, ds) ->
  api = new nedb cfg, app
