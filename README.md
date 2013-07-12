rest-nedb-cache
===============

This is still very early in dev, it works -- but I am still optimizing things, if you find any issues you know what to do :)

This module will give you a simple file/memory based cache with [nedb](https://github.com/louischatriot/nedb). (ps, i love nedb, you should too.)

### Features
- Super fast `nedb` file/memory backed cache w/ simple garbage collection
- 100% coffeescript, hate it or love it
- restful api routing supporting "GET", "POST", "PUT", "DELETE" requests
- parses json/multi-part
- flexible


### Installation
```cs
  nedb = require "rest-nedb-cache"
  new nedb {
    prefix: "/session"
    version: "/v1"
  }, app
```


