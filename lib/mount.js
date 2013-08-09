(function() {
  var crudify, path, util, _;

  _ = require("underscore");

  path = require("path");

  util = require("util");

  crudify = require("./crudify");

  module.exports = function(opts, app) {
    var mid, router, self, uri, _i, _len, _ref;
    this.prefix = "/ds";
    this.version = "/v1";
    this.middleware = [];
    this.exclude = [];
    this.maxAge = 1000 * 60 * 60;
    if (opts != null) {
      _.extend(this, opts);
    }
    uri = util.format((this.version != null) || this.version !== false ? this.prefix + this.version : this.prefix);
    self = this;
    router = function(req, res) {
      return crudify(self, req, function(err, resp) {
        if (err != null) {
          res.status(400);
          return res.send(err);
        } else {
          return res.send(resp);
        }
      });
    };
    if (this.middleware.length > 0) {
      _ref = this.middleware;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mid = _ref[_i];
        app.all(uri, mid);
        app.all(uri + "/:id", mid);
      }
    }
    app.all(uri, router);
    app.all(uri + "/:id", router);
    return this;
  };

}).call(this);
