_ = require "lodash"

# extend nedb to give us a Schema we can generate easily with a stale timestamp
# this will allow us to do a very simpe garbage collection for these `temporary`
# objects

extended = (ds) ->

  @garbageCollection = (fn) ->
    ds.remove {stale: {$lt: Date.now()}}, {multi: true}, (err, count) ->
      return if err? then fn err, null
      fn null, count

  _.extend @, ds

  self = @

  ds.loadDatabase (err) ->
    return if err? then throw err
    # run this once, because it's okay.
    self.garbageCollection (err, removed) ->
      return if err? throw err
      if removed > 0
        console.log "NeDB: sent #{removed} items to garbarge collection"

    setInterval ->
      self.garbageCollection (err, removed) ->
        return if err? throw err
        if removed > 0
          console.log "NeDB: sent #{removed} items to garbarge collection"
    , 1000 * 60 * 10 # setting this to ten minute increments should do the trick.

  @

# Schema takes opts, and you can really extend that to as large as you'd like
extended::Schema = (opts, ds) ->

  stale = 1000 * 60 * 60
  
  @stale = stale

  @store = undefined
  
  if opts? then _.extend @, opts

  # check for override of `@stale`
  if @_stale? 
    @stale = @_stale
    # clear this out w/ `undefined` so it doesn't get
    # stored into the doc
    @_stale = undefined 

  self = @
  
  if @stale? or @stale != false
    setTimeout ->
      ds.garbageCollection (err, count) ->
        return if err? then throw err else if count > 0 then console.log "removed #{count} items from cache"
    , self.stale

    @stale = Date.now() + parseInt self.stale

  else
    @stale = undefined

  @

module.exports = extended
