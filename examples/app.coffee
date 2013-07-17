### Examples Usage ###
# copy & paste this into your express app.coffee
# then run `npm install && coffee app.coffee

express = require "express"
app = express()

nedb = require "./restify"

server = require("http").createServer app

app.set "port", 1337

app.use express.compress()
# include stuff to do only when we're in 
# a development environment
if process.env.NODE_ENV == "development"
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true
  app.use express.logger "dev"

# app.use app.router # still doesn't seem to do much..
# statics, favicon poo
app.use express.favicon()

# Form Handling, MethodOverride, bodyParser
app.use express.methodOverride()
app.use express.bodyParser 
  keepExtensions: true

# we're going to mount the application to our 
# express app, modular style.
app.use nedb

# csrf protection, only call this on areas
# you want protection, ideally any admin/backend
# as well as accounts/auth stuff - as a rule.
# app.use express.csrf()

# app.use otherRoutes
# app.get "otherRoute", middle, route

# start this train! woo woo!
server.listen app.get("port"), () ->
  console.log ":: restify-nedb example :: started!"
