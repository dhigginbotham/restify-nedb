_ = require "underscore"
path = require "path"
util = require "util"

# nedb file backed data store
crudify = require "./crudify"

module.exports = (opts, app) ->
  # route prefix, change this to something else, default is going to be
  # "/ds" (for DataStore).
  
  # set default
  @prefix = "/ds"

  # set default, remove with `null` or `false`
  @version = "/v1"

  @middleware = []

  @exclude = []

  @maxAge = 1000 * 60 * 60

  if opts? then _.extend @, opts

  # define our route uri w/ version, etc
  uri = util.format if @version? or @version != false then @prefix + @version else @prefix

  self = @

  # router, output either our errors or a successful response.
  router = (req, res) ->

    # call our crudify method that will add our cache extension
    # and make our json outputs
    crudify self, req, (err, resp) ->
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

  # default route
  app.all uri, router

  # set our app to listen for `:id`
  app.all uri + "/:id", router

  @
