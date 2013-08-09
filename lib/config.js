(function() {
  var DataStore, config, fs, path, _;

  DataStore = require('nedb');

  _ = require("lodash");

  fs = require("fs");

  path = require("path");

  config = function(opts) {
    /* set default opts*/

    this.prefix = "/ds";
    this.version = "/v1";
    this.middleware = [];
    this.exclude = [];
    this.memoryStore = false;
    this.fileName = "nedb-filestore.db";
    this.filePath = path.join(__dirname, "..", "db");
    this.store = void 0;
    this.maxAge = 1000 * 60 * 60;
    if (opts != null) {
      _.extend(this, opts);
    }
    if (this.file_name != null) {
      console.log("`file_name` is deprecated, please use `fileName` in your config file");
      this.fileName = this.file_name;
    }
    if (this.file_path != null) {
      console.log("`file_path` is deprecated, please use `filePath` in your config file");
      this.filePath = this.file_path;
    }
    if (this.memory_store != null) {
      console.log("`memory_store` is deprecated, please use `memoryStore` in your config file");
      this.memoryStore = this.memory_store;
    }
    return this;
  };

  config.prototype.makeDateStore = function(fn) {
    var self;
    self = this;
    if (this.memoryStore === false) {
      this.ds = new DataStore({
        filename: path.join(self.filePath, self.fileName)
      });
    } else {
      this.ds = new DataStore();
    }
    if ((fn != null) && typeof fn !== "undefined" && _.isFunction(fn)) {
      return fn(null, this);
    } else {
      return this;
    }
  };

  config.prototype.inherit = function(opts) {
    if (opts != null) {
      _.extend(this, opts);
    }
    return this;
  };

  module.exports = config;

}).call(this);
