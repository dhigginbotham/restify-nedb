### Examples Usage ###
# copy & paste this into your express app directory and 
# include it like we have in `app.coffee`

_ = require "underscore"
express = require "express"
app = module.exports = express()

nedb = require("restify-nedb").mount

cfg = require "./config"

cfg.ds (err, ds) ->
  api = new nedb cfg, app
