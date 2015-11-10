var express = require('express');
var app = express();
var server = require('http').createServer(app);

app.set('port', 1337);

app.use(express.compress());
app.use(express.methodOverride());
app.use(express.bodyParser());

var restify = require('../lib').mount;
var config = require('../lib').config;

var path = require('path');

// some sample middlware to throw at it
var sampleMiddleware = function (req, res, next) {
  console.log('here\'s a sample middleware...');
  return next();
};

// default config options
var opts = {
  filePath: path.join(__dirname,'db'),
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

cfg.makeDataStore(function(err) {
  if (!err) {
    api = new restify(cfg, app);
  }
});

server.listen(app.get('port'), function () {
  console.log('restify-nedb example listening on %s', app.get('port'));
});
