_ = require "underscore"
fs = require "fs"
path = require "path"

config = (opts) ->

  # purposefully make this privatish for now
  @file_name = "nedb-filestore.db"
  @file_path = path.join __dirname, "..", "db"
  @memory_store = false

  @store = undefined
  @maxAge = 1000 * 60 * 60

  self = @

  if opts? then _.extend @, opts

  @

config::ds = (fn) ->
  
  self = @
  
  if @memory_store == false
    @ds = _.extend self, new DataStore filename: path.join self.file_path, self.file_name
  else
    @ds = _.extend self, new DataStore()

  fn null, @

config::inherit = (opts) ->
  
  if opts? then _.extend @, opts

  @

module.exports = config