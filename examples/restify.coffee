### Examples Usage ###
# copy & paste this into your express app directory and 
# include it like we have in `app.coffee`

express = require "express"
app = module.exports = express()

nedb = require("restify-nedb").mount
ensure = require "../passport/middleware"

new nedb {
  prefix: "/session"
  middleware: [ensure.admins]
  exclude: ['_id', 'stale']
  cache: 
    maxAge: 1000 * 60 * 60
}, app
