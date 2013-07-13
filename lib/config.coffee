DataStore = require 'nedb'
_ = require "underscore"
fs = require "fs"
path = require "path"

config = (opts) ->

  ### set default opts ###

  # default settings for restify server 
  @prefix = "/ds"
  @version = "/v1"
  @middleware = []
  @exclude = []

  @memoryStore = false

  # default settings for internal nedb process
  @fileName = "nedb-filestore.db"
  @filePath = path.join __dirname, "..", "db"
  @store = undefined
  @maxAge = 1000 * 60 * 60

  if opts? then _.extend @, opts

  if @file_name? 
    console.log "`file_name` is deprecated, please use `fileName` in your config file"
    @fileName = @file_name
  if @file_path?
    console.log "`file_path` is deprecated, please use `filePath` in your config file"
    @filePath = @file_path
  if @memory_store?
    console.log "`memory_store` is deprecated, please use `memoryStore` in your config file"
    @memoryStore = @memory_store
    
  @

config::ds = (fn) ->
  
  self = @
  
  if @memoryStore == false
    @ds = new DataStore filename: path.join self.filePath, self.fileName
  else
    @ds = new DataStore()

  fn null, @ds

config::inherit = (opts) ->
  
  if opts? then _.extend @, opts

  @

module.exports = config
