// require testing modules
var expect = require('expect.js');
var request = require('superagent');
var async = require('async');

// build out express application for testing purposes
var express = require('express');
var app = express();

var server = require('http').createServer(app);

app.set('port', 1338);
app.use(express.methodOverride());
app.use(express.bodyParser());

var uri = "http://localhost:" + app.get('port');

// include nedb, and it's requirements
var nedbConf = require('../lib').config;
var nedbMount = require('../lib').mount;

var path = require("path");

var fs = require("fs");

var opts = {
  filePath: path.join(__dirname, "db"),
  maxAge: 1000 * 60 * 60,
  prefix: "/session"
};

var config = new nedbConf(opts);

config.makeDateStore(function (err, ds) {
  new nedbMount(config, app);
});

describe('starting restify-nedb test scripts', function () {

  it('should listen for our server', function (done) {

    // fire up the bass cannon
    server.listen(app.get('port'), function () {
      done();
    });

  });

  it('should have wired everything up, lets go!', function (done) {
    
    expect(config.prefix).to.be('/session');
    expect(config.version).to.be('/v1');
    expect(config.middleware).to.be.an('array');
    expect(config.exclude).to.be.an('array');
    expect(config.ds).to.be.an('object');
    expect(config.maxAge).to.be.a('number');

    done();

  });

  it('should response with a good statusCode', function (done) {

    request.get(uri + '/session/v1', function(err, resp) {
      
      expect(err).to.be(null);
      expect(resp.statusCode).to.equal(200);
      expect(resp.body).to.be.an('array');

      done();
    });

  });

  it('should add a new document to nedb', function (done) {

    var test = {test: "test posting new object"};

    request.post(uri + '/session/v1').send(test).end(function (err, resp) {
      
      expect(err).to.be(null);
      expect(resp.statusCode).to.equal(200);
      expect(resp.body).to.be.a('object');

      done();

    });

  });

});

describe('batch add multiple files to nedb', function () {

  it('should batch add 100 docs into nedb', function (done) {

    var postData = function (index, fn) {
      request.post(uri + '/session/v1').send({test: "test posting new object"}).end(function (err, resp) {
        fn(null, resp.body);
      });
    };

    async.times(100, function (n, next) {
      postData(n, function (err, user) {
        next(err,user);
      });
    }, function (err, users) {
      if (users) {
        done();
      }
    });

  });

});

process.on("SIGINT", function () {
  server.exit(0);
});
