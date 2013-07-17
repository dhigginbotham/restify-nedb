# restify-nedb (for [nedb](https://github.com/louischatriot/nedb))

![](https://api.travis-ci.org/dhigginbotham/restify-nedb.png)

`restify-nedb` was built to give you restful api resources for client side application frameworks like `angular.js`, `ember.js`, `backbone.js` or `knockout.js` as well as give you a simple file/memory based cache utilizing [nedb](https://github.com/louischatriot/nedb). (ps, i love [nedb](https://github.com/louischatriot/nedb), you should too.) If you haven't already checked it out, maybe you want to use it separate of all of this extra stuff, do it. It's like sqlite, with a subset of mongodb's api. _Really neat._

### Heads up, she's still a baby
- Let me know if you have any issues, please open issues/prs etc, it's a lot more fun that way
- There's still a good chunk of the `nedb` api I need to wrap in, if you need the core crud stuff, this should work well for you
- I'd like to point out there coule be a few rough parts, but it's coming along.  

### Features
- Super fast `nedb` file/memory backed cache w/ simple garbage collection
- 100% coffeescript, hate it or love it 
- restful routing: `GET`, `POST`, `PUT`, `DELETE` 
- parses `json/multi-part`

### Installation (w/ Express)

##### Step 1) Install the app, automatically add the latest version in your `package.json`

```
npm install restify-nedb --save
```

##### Step 2) Configure your app, needs access to `app`, so you can do that a number of ways, `req.app`, `res.app`, `app.use`, `app`, etc..

```coffee
express = require "express"
app = module.exports = express()

nedb = require("restify-nedb").mount
config = require("restify-nedb").config
ensure = require "../passport/middleware"

opts = 
  filePath: conf.app.paths.cache
  maxAge: 1000 * 60 * 60
  prefix: "/session"
  middleware: [ensure.admins]

cfg = new config opts

# cfg.ds (err, internal) ->
#   api = new nedb internal, app

# or

cfg.ds()
api = new nedb cfg, app
```

##### Step 3) Submit bugs and nasties [here](https://github.com/dhigginbotham/restify-nedb/issues).

## Configuration Options
Options | Defaults | Type | Infos
--- | --- | --- | ---
**ds** | `internal` | DataStore | allow for outside nedb processes to be restified. tip: `config.ds()` returns a new DataStore with whatever your `opts` are set to, once it's fired it will internalize and share
**prefix** | `/ds` | String | defines the first route path, for instance `http://localhost:3000/ds`
**version** | `/v1` | String | not preferred, as a rule i feel these aren't the best idea for your api, last thing you want is fragmentation in your api
**exclude** | `[]` | Array | excludes keys/values from the api, good for things like `password` 
**middleware** | `[]` | Array | middlewares, ie passport authentication, logging, analytics
**memoryStore** | `false` | Boolean | whether or not keep an in-memory store or a file based persistant store, defaults to `false`, we like persistant files.
**fileName** | `nedb-filestore.db` | String | file name for your nedb filestore
**filePath** | `../db` | String | bit easier to change the path and view the contents instead of digging through `node_modules`
**maxAge** | `1000 * 60 * 60` | Number | if set to `null` or `false` automated gc will be disabled
**store** | `undefined` | String | `not currently working` - will allow for multiple nedb collections, still working out the kinks.

## Routes

```md
GET http://localhost:3000/session/v1
POST http://localhost:3000/session/v1

GET http://localhost:3000/session/v1/:id
PUT http://localhost:3000/session/v1/:id
DELETE http://localhost:3000/session/v1/:id

GET http://localhost:3000/session/v1?id=:id
PUT http://localhost:3000/session/v1?id=:id
```
### Ordering

```md
GET http://localhost:3000/session/v1?limit=20
GET http://localhost:3000/session/v1?skip=10
GET http://localhost:3000/session/v1?sort=val
GET http://localhost:3000/session/v1?sort=-val
```

### Query / Searching

```md
GET http://localhost:3000/session/v1?key=value
```

### Additional

```md
PUT http://localhost:3000/session/v1/:id?append=true
```
- append defaults to false. Set to true to do something similar to `findAndUpdate`
 
```md
POST http://localhost:3000/session/v1
```

- `_stale` in your body/json will act as an override to `stale`, say you need some things to last longer/shorter than other cached items
 
##### Tests

```md
mocha test\crud.coffee -R spec --compilers coffee:coffee-script
```

##### Pro-tips
- I would recommend using something like [Advanced REST Client](https://chrome.google.com/webstore/detail/advanced-rest-client/hgmloofddffdnphfgcellkdfbfbjeloo?hl=en-US) for testing, it'll help.
- If you want upto date / latest documentation run `cake docs`, this way if I forget, you can easily skim thru the source -- `/docs` should be included.

![](https://nodei.co/npm/restify-nedb.png?downloads=true&stars=true)


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
