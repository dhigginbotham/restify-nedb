# maybe ensure we're using `bodyParser()`
# app.use express.bodyParser()

# underscores is amazing, we'll be using this a lot.
_ = require "underscore"

extendify = require "./extended"

# monkeying around with this... so i can be lazier with additional stuffs.
ds = null

# crudify switch, will handle all acceptable routes and pass json errors
# on unsupported request methods.
crudify = (opts, req, fn) ->

  ds = new extendify opts.ds

  # define schema
  Schema = ds.Schema

  # listen for `req.param('id')` will fallback until it finds the id
  id = if typeof req.params.id != "undefined" and req.params.id? then {_id: req.params.id} else {}
  
  # `append` (Boolean) is a little trick to extend our update 
  # object with its original contents, plus any new content
  append = if req.query? and req.query.append? then true else false

  # `limit` accepts numbers, will limit the response amount 
  limit = if typeof req.query.limit != "undefined" and req.query.limit? then req.query.limit else null
  
  # `skip` works like a champ
  skip = if typeof req.query.skip != "undefined" and req.query.skip? then req.query.skip else null

  # `sort` handles multiples, like a boss. accepts asc/desc ie: "val" "-val"
  sort = if typeof req.query.sort != "undefined" and req.query.sort? then req.query.sort else null

  # define a list of protected querys to listen for and not do
  # searches with them
  privates = ['skip', 'limit', 'append', 'id', 'sort']

  # build out our search/query object
  query = {}

  for key, value of req.query
    if privates.indexOf(key) == -1
      query[key] = value

  # do our switch stuff based on this variable
  method = req.method.toLowerCase()

  # exclusions accepts `['some', 'arr']` probably needs some more 
  # work.
  exclude = if opts.exclude? then opts.exclude else null

  # cache keys array, helpful for length and such, we'll use it to validate
  # proper cache objects later on
  keys = Object.keys req.body

  # if the bodyParser has an object, we're going to create a schema
  # remember each schema has a stale you can override..
  body = null

  # uses `Schema` extension, wee.
  if req.body? and keys.length > 0
    if opts.maxAge? 
      body = new Schema _.extend(req.body, {stale: opts.maxAge, store: opts.store}), ds
    else 
      body = new Schema _.extend(req.body, {stale: null, store: opts.store}), ds

  # on `post` & `put` requests, don't pass go with a null body
  if (method == "post" or method == "put") and body == null 
    return fn error: "You must provide a body to go along with this request.. please try again.", null

  # ensure our delete has an id, otherwise we're its gonna delete randomly?~ out of our cache, das ist bad..
  if (method == "delete") and not id._id?
    return fn error: "One does not always delete the abyss, but when one does, one must include an id", null

  # ensure our datastore is loaded, we don't want to rush anything.
  ds.loadDatabase (err) ->
    return if err? then fn err, null 

    # do our switch, a lot easier this way -- yea
    switch method

      # handle "GET" requests
      # `ds.query` is used
      when "get" then methodHandler.get id, query, (err, datastores) ->
        return if err? then fn err, null

        # fix this silliness... lol
        if exclude.length > 0

          keys = Object.keys datastores
          
          _.each exclude, (element, index, list) ->
            for k in [0..keys.length]
              cur = datastores[k]
              if datastores.indexOf(cur) != -1
                delete datastores[k][element]


        # build out sort options
        if sort? then queryHandler.sort sort, datastores, (err, sorted) ->
          datastores = sorted

        # build out our skip query
        if skip? then queryHandler.skip skip, datastores, (err, skipped) ->
          datastores = skipped

        # check for limit, if it exists -- we're going to 
        # support a limit
        if limit? then queryHandler.limit limit, datastores, (err, limited) ->
          datastores = limited

        fn null, datastores

      # handle "POST" requests
      # `ds.insert` is used
      when "post" then methodHandler.post body, (err, inserted) ->
        return if err? then fn err, null
        fn null, inserted

      # handle "PUT" requests
      # `ds.update` is used
      when "put" then methodHandler.put id, body, append, (err, updated) ->
        return if err? then fn err, null
        fn null, updated

      # handle "DELETE" requests
      # `ds.remove` is used
      when "delete" then methodHandler.delete id, (err, deleted) ->
        return if err? then fn err, null
        fn null, deleted

      # handle "HEAD" requests
      # `ds.remove` is used
      when "head" then methodHandler.head id, (err, header) ->
        return if err? then fn err, null
        fn null, header

      # do error on unsupported requests
      else 
        fn error: "Unsupported http method, please try again.", null

queryHandler = {}

dynamicSort = (property) ->
  sortOrder = 1
  if property[0] is "-"
    sortOrder = -1
    property = property.substr(1, property.length - 1)
  (a, b) ->
    result = (if (a[property] < b[property]) then -1 else (if (a[property] > b[property]) then 1 else 0))
    result * sortOrder

queryHandler.skip = (skip, data, fn) ->
  dataLen = data.length
  arr = data.splice(skip, (dataLen - parseInt(skip)))
  return fn null, arr

queryHandler.limit = (limit, data, fn) ->
  dataLen = data.length
  arr = data.splice(0, limit)
  return fn null, arr

queryHandler.sort = (sort, data, fn) ->
  # thanks to [Ege Özcan's Stackoverflow Answer](http://stackoverflow.com/a/4760279/820066)
    sorted = data.sort dynamicSort sort
    fn null, sorted

methodHandler = {}

methodHandler.get = (id, query, fn) ->

  if _.isFunction query
    fn = query
    query = {}
    
  if _.isObject query then _.extend id, query

  # default query, accepts by `req.query.id` or 
  # an empty object, logic is in the crudify() fn
  ds.find id, (err, datastores) ->
    return if err? then fn err, null
    fn null, datastores
  
methodHandler.post = (insert, fn) ->
  
  # insert, later we'll make a safe insert or something
  # along those lines, maybe something like `findAndUpdate`
  # from supergoose
  ds.insert insert, (err, inserted) ->
    return if err? then fn err, null
    fn null, inserted

methodHandler.delete = (id, fn) ->

  # delete by id, make sure our query is built properly.
  ds.remove id, (err, total) ->
    return if err? then fn err, null
    if total > 0
      resp = _.extend id, {num_deleted: total}
      fn null, resp
    else
      fn error: "No items deleted, please check your id", null

methodHandler.head = (id, fn) ->
  return fn {error: "Unsupported http method, please try again", id: id}, null

methodHandler.put = (id, update, append, fn) ->

  # if append is true we're going to query for our item
  # and extend it, otherwise we're just gonna overwrite it
  if append == true

    # findOne, then extend the object.. magic.
    ds.findOne id, (err, found) ->
      return if err? then fn err, null

      # extend found with update, sweeeet
      _.extend found, update

      ds.update id, found, (err, updated) ->
        return if err? then fn err, null

        # we can assume we're error free, lets extend
        # our response to make more sense, rock and roll!
        
        if updated > 0
          # we've successfully updated something, move on!
          resp = _.extend id, found
          fn null, resp
        else
          # boohoo, we've got trouble.
          fn error: "No items updated, please check your id", null

  # append was false, anything below this is the aftermath.
  else

    # we're not going to append here, so we'll just do a hard update
    ds.update id, update, (err, updated) ->
      return if err? then fn err, null

        # we can assume we're error free, lets extend
        # our response to make more sense, rock and roll!
        
      if updated > 0
        # we've successfully updated something, move on!
        resp = _.extend id, update
        fn null, resp
      else
        # boohoo, we've got trouble.
        fn error: "No items updated, please check your id", null

module.exports = crudify
