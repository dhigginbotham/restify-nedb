## Needs maintainer, or friend with motivation!
I've been busy a lot with work -- and this project while very small has still managed to generate *some* attention, the problem? A couple years ago I got tricked into thinking I'd found a new, better version of JavaScript, CoffeeScript, I was wrong. There's many optimizations I see now that I should have made then... So, well this project has become something of an eye sore for me and I would either like someone else who has the free time to take on this project or someone whose interested in working on a refactor with me.

# restify-nedb (for [nedb](https://github.com/louischatriot/nedb)) <img src="https://drone.io/github.com/dhigginbotham/restify-nedb/status.png" align="right" />
`restify-nedb` was built to give you restful api resources for client side application frameworks like `angular.js`, `ember.js`, `backbone.js` or `knockout.js` as well as give you a simple file/memory based cache utilizing [nedb](https://github.com/louischatriot/nedb). (ps, i love [nedb](https://github.com/louischatriot/nedb), you should too.) If you haven't already checked it out, maybe you want to use it separate of all of this extra stuff, do it. It's like sqlite, with a subset of mongodb's api. _Really neat._

### Features
- Super fast `nedb` file/memory backed cache w/ simple garbage collection
- 100% coffeescript, hate it or love it 
- restful routing: `GET`, `POST`, `PUT`, `DELETE` 
- parses `json/multi-part`
- Let me know if you have any issues, please open issues/prs etc, it's a lot more fun that way

----

<img src="https://nodei.co/npm/restify-nedb.png?downloads=true&amp;stars=true"/>

### Installation

```
npm install restify-nedb --save
```

### Example
```js
var express = require('express');
var app = express();
var server = require('http').createServer(app);

app.set('port', 1337);

app.use(express.compress());
app.use(express.methodOverride());
app.use(express.bodyParser());

var restify = require('restify-nedb').mount;
var config = require('restify-nedb').config;

var path = require('path');

// some sample middlware to throw at it
var sampleMiddleware = function (req, res, next) {
  console.log('here\'s a sample middleware...');
  return next();
};

// default config options
var opts = {
  filePath: path.join(__dirname,'db','filestore.db'),
  maxAge: 1000 * 60 * 60,
  prefix: '/session',
  middleware: [sampleMiddleware]
};

// initialize our config object

cfg = new config(opts);

// if you aren't already using an nedb
// instance, then calling this will create
// one for you.

// accepts sync/blocking

// cfg.makeDataStore();

// api = new restify(cfg, app);

// or async <3

cfg.makeDataStore(function(err, ds_cfg) {
  if (!err) {
    api = new restify(ds_cfg, app);
  };
});

server.listen(app.get('port'), function () {
  console.log('restify-nedb example listening on %s', app.get('port'));
});
```

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

### `config.makeDataStore(err?, callback?)`
- accepts either sync/async flow, if you don't have an `nedb` instance going, use this to create one -- otherwise pass it into your options object.

## Ordering

### `?limit=20`
```md
GET http://localhost:3000/session/v1?limit=20
```
- `if (limit=20)` then it will only return 20 objects, etc.

### `?skip=10`
```md
GET http://localhost:3000/session/v1?skip=10
```
- skip fields, good for paging

### `?sort=val`
```md
GET http://localhost:3000/session/v1?sort=val
```
- sort doc in ascending

### `?sort=-val`
```md
GET http://localhost:3000/session/v1?sort=-val
```

- sort doc in descending order

----

## Query / Searching

### `?key=value`
```md
GET http://localhost:3000/session/v1?key=value
```

- queries matching key/values

## Defaults
```md
GET http://localhost:3000/session/v1
POST http://localhost:3000/session/v1

GET http://localhost:3000/session/v1/:id
PUT http://localhost:3000/session/v1/:id
DELETE http://localhost:3000/session/v1/:id

GET http://localhost:3000/session/v1?id=:id
PUT http://localhost:3000/session/v1?id=:id
```

## Additional

### `?append=true`
```md
PUT http://localhost:3000/session/v1/:id?append=true
```

- append defaults to false. Set to true to do something similar to `findAndUpdate`

### `_stale` override
```md
POST / PUT http://localhost:3000/session/v1
```

- passing `_stale` in your body/json will act as an override to `stale`, say you need some things to last longer/shorter than other cached items

## Tests

```md
npm test
```

## Cake tools
- `cake build:docs` will build annotated source code documentation from docco
- `cake build:coffee` will compile coffee from `/src` to js in `/lib`

## Pro-tips
- I would recommend using something like [Advanced REST Client](https://chrome.google.com/webstore/detail/advanced-rest-client/hgmloofddffdnphfgcellkdfbfbjeloo?hl=en-US) for testing, it'll help.


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
