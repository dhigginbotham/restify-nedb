# maybe ensure we're using `bodyParser()`
# app.use express.bodyParser()

# underscores is amazing, we'll be using this a lot.
_ = require "underscore"

# require your nedb installation
ds = null
# crudify switch, will handle all acceptable routes and pass json errors
# on unsupported request methods.
crudify = (store, req, fn) ->

  st = require "./extended"
  ds = new st store
  Schema = ds.Schema

  # listen for `req.param('id')` will fallback until it finds the id
  query = if req.param("id")? then {_id: req.param("id")} else {}
  
  # `append` (Boolean) is a little trick to extend our update 
  # object with its original contents, plus any new content
  append = if req.query? and req.query.append? then true else false

  # do our switch stuff based on this variable
  method = req.method.toLowerCase()

  # cache keys array, helpful for length and such, we'll use it to validate
  # proper cache objects later on
  keys = Object.keys req.body

  # if the bodyParser has an object, we're going to create a schema
  # remember each schema has a stale you can override..
  body = null

  # uses `Schema` extension, wee.
  if req.body? and keys.length > 0
    body = new Schema req.body
      # stale: 1000 * 60 * 60 # defaulted settings
      # store: req.url # defaulted settings

  # on `post` & `put` requests, don't pass go with a null body
  if (method == "post" or method == "put") and body == null 
    return fn error: "You must provide a body to go along with this request.. please try again.", null

  # ensure our delete has an id, otherwise we're its gonna delete randomly?~ out of our cache, das ist bad..
  if (method == "delete") and not query._id?
    return fn error: "One does not always delete the abyss, but when one does, one must include an id", null

  # ensure our datastore is loaded, we don't want to rush anything.
  ds.loadDatabase (err) ->
    return if err? then fn err, null 

    # do our switch, a lot easier this way -- yea
    switch method
      # handle "GET" requests
      # `ds.query` is used
      when "get" then methodHandler.get query, (err, datastores) ->
        return if err? then fn err, null
        fn null, datastores

      # handle "POST" requests
      # `ds.insert` is used
      when "post" then methodHandler.post body, (err, inserted) ->
        return if err? then fn err, null
        fn null, inserted

      # handle "PUT" requests
      # `ds.update` is used
      when "put" then methodHandler.put query, body, append, (err, updated) ->
        return if err? then fn err, null
        fn null, updated

      # handle "DELETE" requests
      # `ds.remove` is used
      when "delete" then methodHandler.delete query, (err, deleted) ->
        return if err? then fn err, null
        fn null, deleted

      # do error on unsupported requests
      else 
        fn error: "Unsupported http method please try again.", null

methodHandler = {}

methodHandler.get = (query, fn) ->

  # default query, accepts by `req.query.id` or 
  # an empty object, logic is in the crudify() fn
  ds.find query, (err, datastores) ->
    return if err? then fn err, null
    fn null, datastores

methodHandler.post = (insert, fn) ->
  
  # insert, later we'll make a safe insert or something
  # along those lines, maybe something like `findOrUpdate`
  # from supergoose
  ds.insert insert, (err, inserted) ->
    return if err? then fn err, null
    fn null, inserted

methodHandler.delete = (query, fn) ->

  # delete by id, make sure our query is built properly.
  ds.remove query, (err, total) ->
    return if err? then fn err, null
    if total > 0
      resp = _.extend query, {num_deleted: total}
      fn null, resp
    else
      fn error: "No items deleted, please check your id", null

methodHandler.put = (query, update, append, fn) ->

  # if append is true we're going to query for our item
  # and extend it, otherwise we're just gonna overwrite it
  if append == true

    # findOne, then extend the object.. magic.
    ds.findOne query, (err, found) ->
      return if err? then fn err, null

      # extend found with update, sweeeet
      _.extend found, update

      ds.update query, found, (err, updated) ->
        return if err? then fn err, null

        # we can assume we're error free, lets extend
        # our response to make more sense, rock and roll!
        
        if updated > 0
          # we've successfully updated something, move on!
          resp = _.extend query, found
          fn null, resp
        else
          # boohoo, we've got trouble.
          fn error: "No items updated, please check your id", null

  # append was false, anything below this is the aftermath.
  else

    # we're not going to append here, so we'll just do a hard update
    ds.update query, update, (err, updated) ->
      return if err? then fn err, null

        # we can assume we're error free, lets extend
        # our response to make more sense, rock and roll!
        
      if updated > 0
        # we've successfully updated something, move on!
        resp = _.extend query, update
        fn null, resp
      else
        # boohoo, we've got trouble.
        fn error: "No items updated, please check your id", null

module.exports = crudify