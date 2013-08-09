### Examples Usage ###
# copy & paste this into your express app directory and 
# include it like we have in `app.coffee`

_ = require "underscore"
express = require "express"
app = module.exports = express()

nedb = require("../lib").mount

nedbConfig = require("../lib").config
path = require "path"
fs = require "fs"

opts = 
  filePath: path.join __dirname, "db"
  maxAge: 1000 * 60 * 60
  prefix: "/session"
  # middleware: [ensure.admins]

nedbCfg = new nedbConfig opts

nedbCfg.makeDateStore (err, ds) ->
  api = new nedb ds, app
