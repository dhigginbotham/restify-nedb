nedbConfig = require("../lib").config
path = require "path"
fs = require "fs"

opts = 
  filePath: path.join __dirname, "db"
  maxAge: 1000 * 60 * 60
  prefix: "/session"
  # middleware: [ensure.admins]

nedbCfg = new nedbConfig opts

module.exports = nedbCfg
