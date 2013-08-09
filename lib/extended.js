(function() {
  var extended, _;

  _ = require("underscore");

  extended = function(ds) {
    var self;
    this.garbageCollection = function(fn) {
      return ds.remove({
        stale: {
          $lt: Date.now()
        }
      }, {
        multi: true
      }, function(err, count) {
        if (err != null) {
          return fn(err, null);
        }
        return fn(null, count);
      });
    };
    _.extend(this, ds);
    self = this;
    ds.loadDatabase(function(err) {
      if (err != null) {
        throw err;
      }
      self.garbageCollection(function(err, removed) {
        if (typeof err === "function" ? err((function() {
          throw err;
        })()) : void 0) {
          return;
        }
        if (removed > 0) {
          return console.log("NeDB: sent " + removed + " items to garbarge collection");
        }
      });
      return setInterval(function() {
        return self.garbageCollection(function(err, removed) {
          if (typeof err === "function" ? err((function() {
            throw err;
          })()) : void 0) {
            return;
          }
          if (removed > 0) {
            return console.log("NeDB: sent " + removed + " items to garbarge collection");
          }
        });
      }, 1000 * 60 * 10);
    });
    return this;
  };

  extended.prototype.Schema = function(opts, ds) {
    var self, stale;
    stale = 1000 * 60 * 60;
    this.stale = stale;
    this.store = void 0;
    if (opts != null) {
      _.extend(this, opts);
    }
    if (this._stale != null) {
      this.stale = this._stale;
      this._stale = void 0;
    }
    self = this;
    if ((this.stale != null) || this.stale !== false) {
      setTimeout(function() {
        return ds.garbageCollection(function(err, count) {
          if (err != null) {
            throw err;
          } else if (count > 0) {
            return console.log("removed " + count + " items from cache");
          }
        });
      }, self.stale);
      this.stale = Date.now() + parseInt(self.stale);
    } else {
      this.stale = void 0;
    }
    return this;
  };

  module.exports = extended;

}).call(this);
