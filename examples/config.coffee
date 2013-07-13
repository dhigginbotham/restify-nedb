cfg = require("restify-nedb").config

conf = require "../../conf"

opts = 
  file_path: conf.app.paths.cache
  maxAge: 1000 * 60 * 60

nedbCfg = new cfg opts

module.exports = nedbCfg
