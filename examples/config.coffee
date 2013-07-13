nedbConfig = require("restify-nedb").config

conf = require "../../conf"

opts = 
  filePath: conf.app.paths.cache
  maxAge: 1000 * 60 * 60
  prefix: "/session"
  # middleware: [ensure.admins]

nedbCfg = new nedbConfig opts

module.exports = nedbCfg
