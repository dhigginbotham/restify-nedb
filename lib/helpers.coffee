_ = require "underscore"

helpers = (opts) ->

  @data = []

  if opts? then _.extend @, opts

  @

helpers::exclude = (exclude) ->
  
  self = @

  if exclude.length > 0
    keys = Object.keys datastores
    _.each exclude, (element, index, list) ->
      for k in [0..keys.length]
        do (k) ->
          cur = datastores[k]
          if datastores.indexOf(cur) != -1
            delete datastores[k][element]

helpers::skip = (data, limit) ->
  # build out our skip query
  if skip?
    for x in [(skip - 1)..(limit || datastores.length) - 1]
      do (x) ->
        skipped.push datastores[x]

    return fn null, skipped

        # check for limit, if it exists -- we're going to 
        # support a limit

        if limit? and not skip?
          limited = new Array()
          for x in [0..(limit - 1)]
            do (x) ->
              limited.push datastores[x]


module.exports = helpers