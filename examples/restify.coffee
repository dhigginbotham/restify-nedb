### Examples Usage ###
# copy & paste this into your express app directory and 
# include it like we have in `app.coffee`

_ = require "underscore"
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

  merged = _.extend cfg, opts

  api = new nedb merged, app
