express = require "express"
app = module.exports = express()

nedb = require "rest-nedb-cache"
ensure = require "../passport/middleware"

new nedb {
  prefix: "/session"
  middleware: [ensure.admins]
  cache: 
    maxAge: 1000 * 60 * 60
}, app