# express = require "express"
# app = module.exports = express()

util = require "util"
_ = require "underscore"
path = require "path"

# nedb file backed data store
DataStore = require 'nedb'
crudify = require("./crudify")

module.exports = (opts, app) ->
  # route prefix, change this to something else, default is going to be
  # "/ds" (for DataStore).
  
  # set default
  @prefix = "/ds"
  
  # set default, remove with `null`
  @version = "/v1"

  # purposefully make this privatish for now
  @file_name = "nedb-filestore.db"
  @file_path = path.join __dirname, "..", "db"
  @memory_store = false

  @cache = {}
  @cache.store = undefined
<<<<<<< HEAD
  @cache.gc = true
=======
>>>>>>> newest
  @cache.maxAge = 1000 * 60 * 60
  
  if @memory_store == false
    @ds = new DataStore filename: path.join @file_path, @file_name
  else
    @ds = new DataStore() 

  @middleware = []
<<<<<<< HEAD

=======
  
>>>>>>> newest
  if opts? then _.extend @, opts
  if opts.cache? then _.extend @cache, opts.cache

  # if opts.gc? then @cache.enabled = gc

  # define our route uri w/ version, etc
  uri = util.format if @version? then @prefix + @version else @prefix

  self = @

  # router, output either our errors or a successful response.
  router = (req, res) ->
    crudify self.ds, req, self.cache, (err, resp) ->
      if err? 
        res.status 400 # throw a bad request out there..
        res.send err # send that error baby :/
      else
        res.send resp 

  # set app to listen for all router paths
  # will fallback to `req.query` and `req.body`
  if @middleware.length > 0
    for mid in @middleware
      app.all uri, mid
      app.all uri + "/:id", mid

  app.all uri, router

  # set our app to listen for :id
  app.all uri + "/:id", router
