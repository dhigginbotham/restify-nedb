### Examples Usage ###
# copy & paste this into your express app directory and 
# include it like we have in `app.coffee`

express = require "express"
app = module.exports = express()

nedb = require("../lib").mount
config = require("../lib").config

opts = 
  maxAge: 1000 * 60 * 60
  prefix: "/session"

cfg = new config opts

cfg.ds (err, ds) ->
  api = new nedb cfg, app