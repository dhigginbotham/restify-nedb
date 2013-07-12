restify-nedb (for [nedb](https://github.com/louischatriot/nedb))
===============

restify-nedb was built to give you restful api resources for client side application frameworks like `angular.js`, `ember.js`, `backbone.js` or `knockout.js` as well as give you a simple file/memory based cache utilizing [nedb](https://github.com/louischatriot/nedb). (ps, i love nedb, you should too.) If you haven't already checked it out, maybe you want to use it separate of all of this extra stuff, do it. It's like sqlite, with a subset of mongodb's api. Really neat.

Let me know if you have any issues, please open issues/prs etc, it's a lot more fun that way :neckbeard:
----

### Features
- Super fast `nedb` file/memory backed cache w/ simple garbage collection
- 100% coffeescript, hate it or love it
- restful routing: `"GET", "POST", "PUT", "DELETE"` 
- parses json/multi-part

### Installation (w/ Express)

`npm install git+https://github.com/dhigginbotham/restify-nedb --save`

```coffee
  express = require "express"
  app = module.exports = express()

  nedb = require "restify-nedb"
  ensure = require "../passport/middleware"

  new nedb {
    prefix: "/session"
    middleware: [ensure.admins]
    cache: 
      maxAge: 1000 * 60 * 60
  }, app
```
----

##### Usage
I would recommend using something like [Advanced REST Client](https://chrome.google.com/webstore/detail/advanced-rest-client/hgmloofddffdnphfgcellkdfbfbjeloo?hl=en-US) for testing, it'll help. 

##### Settings
- `prefix` defaults to `/ds`
- `version` defaults to `/v1`
- `middleware` array of middleware, defaults to `[]`
- `memory_store` defaults to false
- `file_name` defaults to `nedb-filestore.db`
- `file_path` defaults to `../db`
- `cache.store` defaults to `undefined` set a store name
- `cache.maxAge` defaults to 1hour or `1000 * 60 * 60`
- `ds` not recommended to overwrite, but you have access if you need it..

##### Basic
```
GET http://localhost:3000/session/v1
GET http://localhost:3000/session/v1/:id
POST http://localhost:3000/session/v1
PUT http://localhost:3000/session/v1/:id
DELETE http://localhost:3000/session/v1/:id
```

##### Options
- `append` is a Boolean option, if append is `true` your update appends to the collection, however if it is `false` it will overwrite everything in that doc

```
PUT http://localhost:3000/session/v1/:id?append=true
```


## License
```md
The MIT License (MIT)

Copyright (c) 2013 David Higginbotham 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
