request = require "request"
expect = require "expect.js"
_ = require "underscore"

uri = "http://localhost:3000"
_id = null

describe "restify-nedb crud tests", () ->

  describe "GET /session/v1", () ->
    it "should respond with status 200", (done) ->
    
      request uri + "/session/v1", (err, resp, body) ->
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        expect(err).to.be(null)
        _id = body[0]._id
        done()

  describe "GET /session/v1/#{_id}", () ->
    it "should return a single result matching it's _id", (done) ->

      request "#{uri}/session/v1/#{_id}", (err, resp, body) ->
        expect(resp.statusCode).to.eql(200)
        expect(body).not.to.be(undefined)
        expect(err).to.be(null)
        expect(body._id).to.be(_id)
        expect(body.stale)
        done()
