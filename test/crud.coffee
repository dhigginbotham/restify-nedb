request = require "request"
expect = require "expect.js"
_ = require "underscore"

express = require "express"
app = express()

###########################################
# run tests w/ mocha (npm install mocha -g)
# mocha test\crud.coffee -R spec --compilers coffee:coffee-script
###########################################

uri = "http://localhost:1337"
_id = null

describe "restify-nedb crud tests", () ->

  describe "POST insert new test seed data", () ->
    it "should return a new item that matches our seed data", (done) ->

      opts = {uri: "#{uri}/session/v1", form: {test: "test posting new object"}, method: "post"}

      request opts, (err, resp, body) ->
        expect(err).to.be(null)
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        json = JSON.parse body
        _id = json._id
        expect(_id).not.to.be(undefined)
        expect(json.stale).not.to.be(undefined)
        done()

  describe "POST insert 100 docs into our cache", () ->
    it "should add 100 docs into our cache with a 1 minute stale", (done) ->

      opts = {uri: "#{uri}/session/v1", form: {test: "test posting new object", _stale: 1000 * 60}, method: "post"}

      for i in [1..100]
        do (i) ->
          request opts, (err, resp, body) ->
            expect(err).to.be(null)
            expect(resp.statusCode).to.eql(200)
            expect(body).not.to.be(undefined)
            json = JSON.parse body
            expect(json.stale).not.to.be(undefined)

      done()

  describe "GET by _id", () ->
    it "should return a single result matching it's _id", (done) ->

      request "#{uri}/session/v1/#{_id}", (err, resp, body) ->
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        expect(err).to.be(null)
        json = JSON.parse body
        _id = json[0]._id
        expect(_id).not.to.be(undefined)
        expect(json[0].stale).not.to.be(undefined)
        done()

  describe "PUT", () ->
    it "should update our test object without appending", (done) ->
      opts = {uri: "#{uri}/session/v1/#{_id}", form: {test: "test updating an object without appending"}, method: "put"}

      request opts, (err, resp, body) ->
        expect(err).to.be(null)
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        done()

  describe "PUT ?=append=true", () ->
    it "should update our test object with append", (done) ->

      query = "?append=true"
      opts = {uri: "#{uri}/session/v1/#{_id}#{query}", form: {append: "test updating an object with append"}, method: "put"}

      request opts, (err, resp, body) ->
        expect(err).to.be(null)
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        done()

  describe "GET", () ->
    it "should respond with status 200", (done) ->
    
      request uri + "/session/v1", (err, resp, body) ->
        expect(err).to.be(null)
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        done()

  describe "DELETE our seed data", () ->
    it "should delete our seed data", (done) ->

      opts = {uri: "#{uri}/session/v1/#{_id}", method: "delete"}

      request opts, (err, resp, body) ->
        expect(err).to.be(null)
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        json = JSON.parse body
        expect(json.num_deleted).to.be(1)
        expect(json._id).to.equal(_id)
        done()

  describe "POST insert new test seed data with a `_stale` override", () ->
    
    it "should return a new item that matches our seed data", (done) ->

      opts = {uri: "#{uri}/session/v1", form: {test: "test posting new object", _stale: 5000}, method: "post"}

      request opts, (err, resp, body) ->
        expect(err).to.be(null)
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        json = JSON.parse body
        _id = json._id
        expect(_id).not.to.be(undefined)
        expect(json.stale).not.to.be(undefined)
        done()

  describe "Test ?limit=5", () ->
    it "should respond with a length of 5", (done) ->
      request uri + "/session/v1?limit=5", (err, resp, body) ->
        expect(err).to.be(null)
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        json = JSON.parse body
        expect(json.length).to.be(5)
        done()

  describe "Test ?limit=5&skip=5", () ->
    it "should skip the first 5", (done) ->
      request uri + "/session/v1?limit=5&skip=5", (err, resp, body) ->
        expect(err).to.be(null)
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        json = JSON.parse body
        expect(json.length).to.be(5)
        done()
