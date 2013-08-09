(function() {
  var crudify, ds, dynamicSort, extendify, methodHandler, queryHandler, _;

  _ = require("underscore");

  extendify = require("./extended");

  ds = null;

  crudify = function(opts, req, fn) {
    var Schema, append, body, exclude, id, key, keys, limit, method, privates, query, skip, sort, value, _ref;
    ds = new extendify(opts.ds);
    Schema = ds.Schema;
    id = req.param("id") != null ? {
      _id: req.param("id")
    } : {};
    append = (req.query != null) && (req.query.append != null) ? true : false;
    limit = req.param("limit") != null ? req.param("limit") : null;
    skip = req.param("skip") != null ? req.param("skip") : null;
    sort = req.param("sort") != null ? req.param("sort") : null;
    privates = ['skip', 'limit', 'append', 'id', 'sort'];
    query = {};
    _ref = req.query;
    for (key in _ref) {
      value = _ref[key];
      if (privates.indexOf(key) === -1) {
        query[key] = value;
      }
    }
    method = req.method.toLowerCase();
    exclude = opts.exclude != null ? opts.exclude : null;
    keys = Object.keys(req.body);
    body = null;
    if ((req.body != null) && keys.length > 0) {
      if (opts.maxAge != null) {
        body = new Schema(_.extend(req.body, {
          stale: opts.maxAge,
          store: opts.store
        }), ds);
      } else {
        body = new Schema(_.extend(req.body, {
          stale: null,
          store: opts.store
        }), ds);
      }
    }
    if ((method === "post" || method === "put") && body === null) {
      return fn({
        error: "You must provide a body to go along with this request.. please try again."
      }, null);
    }
    if ((method === "delete") && (id._id == null)) {
      return fn({
        error: "One does not always delete the abyss, but when one does, one must include an id"
      }, null);
    }
    return ds.loadDatabase(function(err) {
      if (err != null) {
        return fn(err, null);
      }
      switch (method) {
        case "get":
          return methodHandler.get(id, query, function(err, datastores) {
            if (err != null) {
              return fn(err, null);
            }
            if (exclude.length > 0) {
              keys = Object.keys(datastores);
              _.each(exclude, function(element, index, list) {
                var cur, k, _i, _ref1, _results;
                _results = [];
                for (k = _i = 0, _ref1 = keys.length; 0 <= _ref1 ? _i <= _ref1 : _i >= _ref1; k = 0 <= _ref1 ? ++_i : --_i) {
                  cur = datastores[k];
                  if (datastores.indexOf(cur) !== -1) {
                    _results.push(delete datastores[k][element]);
                  } else {
                    _results.push(void 0);
                  }
                }
                return _results;
              });
            }
            if (sort != null) {
              queryHandler.sort(sort, datastores, function(err, sorted) {
                return datastores = sorted;
              });
            }
            if (skip != null) {
              queryHandler.skip(skip, datastores, function(err, skipped) {
                return datastores = skipped;
              });
            }
            if (limit != null) {
              queryHandler.limit(limit, datastores, function(err, limited) {
                return datastores = limited;
              });
            }
            return fn(null, datastores);
          });
        case "post":
          return methodHandler.post(body, function(err, inserted) {
            if (err != null) {
              return fn(err, null);
            }
            return fn(null, inserted);
          });
        case "put":
          return methodHandler.put(id, body, append, function(err, updated) {
            if (err != null) {
              return fn(err, null);
            }
            return fn(null, updated);
          });
        case "delete":
          return methodHandler["delete"](id, function(err, deleted) {
            if (err != null) {
              return fn(err, null);
            }
            return fn(null, deleted);
          });
        case "head":
          return methodHandler.head(id, function(err, header) {
            if (err != null) {
              return fn(err, null);
            }
            return fn(null, header);
          });
        default:
          return fn({
            error: "Unsupported http method, please try again."
          }, null);
      }
    });
  };

  queryHandler = {};

  dynamicSort = function(property) {
    var sortOrder;
    sortOrder = 1;
    if (property[0] === "-") {
      sortOrder = -1;
      property = property.substr(1, property.length - 1);
    }
    return function(a, b) {
      var result;
      result = (a[property] < b[property] ? -1 : (a[property] > b[property] ? 1 : 0));
      return result * sortOrder;
    };
  };

  queryHandler.skip = function(skip, data, fn) {
    var arr, dataLen;
    dataLen = data.length;
    arr = data.splice(skip, dataLen - parseInt(skip));
    return fn(null, arr);
  };

  queryHandler.limit = function(limit, data, fn) {
    var arr, dataLen;
    dataLen = data.length;
    arr = data.splice(0, limit);
    return fn(null, arr);
  };

  queryHandler.sort = function(sort, data, fn) {
    var sorted;
    sorted = data.sort(dynamicSort(sort));
    return fn(null, sorted);
  };

  methodHandler = {};

  methodHandler.get = function(id, query, fn) {
    if (_.isFunction(query)) {
      fn = query;
      query = {};
    }
    if (_.isObject(query)) {
      _.extend(id, query);
    }
    return ds.find(id, function(err, datastores) {
      if (err != null) {
        return fn(err, null);
      }
      return fn(null, datastores);
    });
  };

  methodHandler.post = function(insert, fn) {
    return ds.insert(insert, function(err, inserted) {
      if (err != null) {
        return fn(err, null);
      }
      return fn(null, inserted);
    });
  };

  methodHandler["delete"] = function(id, fn) {
    return ds.remove(id, function(err, total) {
      var resp;
      if (err != null) {
        return fn(err, null);
      }
      if (total > 0) {
        resp = _.extend(id, {
          num_deleted: total
        });
        return fn(null, resp);
      } else {
        return fn({
          error: "No items deleted, please check your id"
        }, null);
      }
    });
  };

  methodHandler.head = function(id, fn) {
    return fn({
      error: "Unsupported http method, please try again",
      id: id
    }, null);
  };

  methodHandler.put = function(id, update, append, fn) {
    if (append === true) {
      return ds.findOne(id, function(err, found) {
        if (err != null) {
          return fn(err, null);
        }
        _.extend(found, update);
        return ds.update(id, found, function(err, updated) {
          var resp;
          if (err != null) {
            return fn(err, null);
          }
          if (updated > 0) {
            resp = _.extend(id, found);
            return fn(null, resp);
          } else {
            return fn({
              error: "No items updated, please check your id"
            }, null);
          }
        });
      });
    } else {
      return ds.update(id, update, function(err, updated) {
        var resp;
        if (err != null) {
          return fn(err, null);
        }
        if (updated > 0) {
          resp = _.extend(id, update);
          return fn(null, resp);
        } else {
          return fn({
            error: "No items updated, please check your id"
          }, null);
        }
      });
    }
  };

  module.exports = crudify;

}).call(this);
