### restify-nedb ###

# mount export will allow you to mount the app routes to your express application
exports.mount = require "./mount"

# if you use your own process of nedb and would like to create schemas/cache etc you can use this

# usage:
#   extend = require("restify-nedb").extended

#   schema =
#     name: "dave"
#     email: "some@email.com"
#     phone: 411
#     can_contact: true
#     # use this option to turn off cache
#     stale: false

#    Schema = new extend schema

exports.extended = require "./extended"

# build a config, includes a ds prototype you can call after initializing
# the config object

exports.config = require "./config"