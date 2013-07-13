### Examples Usage ###
# copy & paste this into your express app directory and 
# include it like we have in `app.coffee`

express = require "express"
app = module.exports = express()

nedb = require("restify-nedb").mount
ensure = require "../passport/middleware"

cfg = require "./config"

cfg.ds (err, ds) ->

  opts = 
    prefix: "/session"
    middleware: [ensure.admins]
    ds: ds

  api = new nedb opts, app