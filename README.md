rest-nedb-cache
===============

### Heads up! This is still very early in dev, it works, I just haven't extended many of the subset mongo api given by `nedb`

This module will give you a simple file/memory based cache with [nedb](https://github.com/louischatriot/nedb). (ps, i love nedb, you should too.)

### Features
- Super fast `nedb` file/memory backed cache w/ simple garbage collection
- 100% coffeescript, hate it or love it
- restful api routing supporting "GET", "POST", "PUT", "DELETE" requests
- parses json/multi-part
- flexible

### Installation (w/ Express)
```cs
  express = require "express"
  app = module.exports = express()
  
  nedb = require "rest-nedb-cache"
  ensure = require "../passport/middleware"
  
  new nedb {
    prefix: "/session"
    middleware: [ensure.admins]
  }, app
```

### Usage
I would recommend using something like [Advanced REST Client](https://chrome.google.com/webstore/detail/advanced-rest-client/hgmloofddffdnphfgcellkdfbfbjeloo?hl=en-US) for testing, it'll help. 

##### Basic
```
GET http://localhost:3000/session/v1
GET http://localhost:3000/session/v1/:id
POST http://localhost:3000/session/v1
PUT http://localhost:3000/session/v1/:id
DELETE http://localhost:3000/session/v1/:id
```

##### Extended
`append` is a Boolean option, if append is `true` your update appends to the collection, however if it is `false` it will overwrite everything in that doc
```
PUT http://localhost:3000/session/v1/:id?append=true
```
